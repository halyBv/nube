# Imagen base ASP.NET (runtime) - .NET 8 LTS
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Imagen para compilar (SDK) - .NET 8 LTS
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["practicas/practicas.csproj", "practicas/"]
RUN dotnet restore "./practicas/practicas.csproj"
COPY . .
WORKDIR "/src/practicas"
RUN dotnet build "./practicas.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./practicas.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "practicas.dll"]
