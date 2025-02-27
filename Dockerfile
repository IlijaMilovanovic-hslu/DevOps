﻿FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env
WORKDIR /App

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore

RUN dotnet build -c Release

RUN dotnet test --no-build -c Release

# Build and publish a release
RUN dotnet publish -c Release --property:PublishDir=/App/out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /App
COPY --from=build-env /App/out .
ENTRYPOINT ["dotnet", "WebAPI.dll"]