# Stage 1: SDK for Building
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /source
COPY *.csproj .
RUN dotnet restore

COPY . .
RUN dotnet publish -c release -o /app --no-restore

# Stage 2: Runtime Only (Security & Size)
FROM mcr.microsoft.com/dotnet/runtime:7.0
WORKDIR /app
COPY --from=build /app .
# Running as a non-root user (Best Practice)
RUN adduser --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser
ENTRYPOINT ["dotnet", "worker.dll"]
