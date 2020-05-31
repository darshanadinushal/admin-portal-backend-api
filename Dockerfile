FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["app.adminportal.api.csproj", ""]
RUN dotnet restore "adminportal.api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "app.adminportal.api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "app.adminportal.api.csproj" -c Release -o /app/publish

FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/app.adminportal.api/dist .
COPY nginx.conf /etc/nginx/nginx.conf
