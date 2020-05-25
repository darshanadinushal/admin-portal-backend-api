#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-nanoserver-1903 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-nanoserver-1903 AS build
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