# Cangjie CI Homework

This project demonstrates a Cangjie unit test environment running in a CI/CD pipeline.

## CI/CD Platform

- Primary pipeline: Jenkins local pipeline
- Jenkins pipeline file: `Jenkinsfile`
- Runner: local Windows machine
- Cangjie SDK: `cangjie-sdk-windows-x64-1.0.5.zip`

GitHub Actions was also prepared, but the GitHub-hosted runner could not start because the account was locked by a billing issue. Jenkins is used as the final CI/CD platform because it does not require GitHub-hosted runner billing.

## Project Structure

```text
Jenkinsfile
src/add.cj
tests/add_test.cj
.ci/run-tests-windows.ps1
.github/workflows/cangjie-unit-test.yml
```

## Local Test

Run the unit test with the local SDK zip:

```powershell
.\.ci\run-tests-windows.ps1 -SdkZip "C:\Users\cdk\Downloads\cangjie-sdk-windows-x64-1.0.5.zip"
```

The script extracts the SDK, loads `envsetup.ps1`, prints `cjc -v`, compiles the unit test, and runs the generated test executable.

## Jenkins Pipeline Test

Create a Jenkins Pipeline job and point it at this project. The pipeline reads `Jenkinsfile` and runs these stages:

```text
Check workspace
Check Cangjie SDK
Run Cangjie unit tests
Archive target artifacts
```

The default SDK path in `Jenkinsfile` is:

```text
C:\Users\cdk\Downloads\cangjie-sdk-windows-x64-1.0.5.zip
```

The test stage compiles and runs:

```powershell
cjc src\add.cj tests\add_test.cj --test -o target\add_test
.\target\add_test
```

To verify the automated test, open the Jenkins build page and check the console output. A successful run should show `Cangjie Compiler: 1.0.5 (cjnative)`, then compile and run the unit test.

## GitHub Actions Note

The repository still contains `.github/workflows/cangjie-unit-test.yml` as an alternative CI configuration. It is not the final selected platform because GitHub returned:

```text
The job was not started because your account is locked due to a billing issue.
```
