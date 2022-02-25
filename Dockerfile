FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["Mednet-App/Mednet-App.csproj", "Mednet-App/"]
RUN dotnet restore "Mednet-App/Mednet-App.csproj"
COPY . .
WORKDIR "/src/Mednet-App"
RUN dotnet build "Mednet-App.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Mednet-App.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Mednet-App.dll"]
