FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY app.adminportal.api.csproj  .
RUN dotnet restore "adminportal.api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "app.adminportal.api.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "app.adminportal.api.csproj" -c Release -o /app

FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/publish/app.adminportal.api/dist .
COPY nginx.conf /etc/nginx/nginx.conf
