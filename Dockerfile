FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
COPY . ./

# copy csproj and restore as distinct layers
RUN dotnet restore
#RUN dotnet test /app/Motix.Microservice.Billing.Tests/Motix.Microservice.Billing.Tests.csproj

# copy everything else and build
WORKDIR /app/RunItInContainer/RunItInContainer
RUN dotnet publish -c Release -o out

# build runtime image
FROM base AS final
ENV ASPNETCORE_ENVIRONMENT="Development"
WORKDIR /app
COPY --from=build-env /app/RunItInContainer/RunItInContainer/out .
ENTRYPOINT ["dotnet", "RunItInContainer.dll"]