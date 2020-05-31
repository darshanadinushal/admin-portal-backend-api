FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 54569

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["app.adminportal.api.csproj", ""]
RUN dotnet restore "./app.adminportal.api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "app.adminportal.api.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "app.adminportal.api.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "app.adminportal.api.dll"]