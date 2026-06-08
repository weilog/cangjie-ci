# Cangjie CI Homework

This project demonstrates a Cangjie unit test environment running in a CI/CD pipeline.

## CI/CD Platform

- Repository: https://github.com/weilog/cangjie-ci
- Pipeline: GitHub Actions
- Runner: `windows-latest`
- Cangjie SDK: `cangjie-sdk-windows-x64-1.0.5.zip`
- SDK release tag: `cangjie-sdk-1.0.5`
- SDK release asset: verified reachable on 2026-06-08

The SDK is stored as a GitHub Release asset instead of being committed to the repository.

## Project Structure

```text
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

## GitHub Actions Test

The workflow runs on `push`, `pull_request`, and `workflow_dispatch`.

It downloads the SDK from:

```text
https://github.com/weilog/cangjie-ci/releases/download/cangjie-sdk-1.0.5/cangjie-sdk-windows-x64-1.0.5.zip
```

Then it compiles and runs:

```powershell
cjc src\add.cj tests\add_test.cj --test -o target\add_test
.\target\add_test.exe
```

To verify the automated test, open the repository's Actions tab and check the latest `Cangjie Unit Test` workflow run.
