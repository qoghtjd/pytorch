call %SCRIPT_HELPERS_DIR%\setup_pytorch_env.bat
:: exit the batch once there's an error
if not errorlevel 0 (
  echo "setup pytorch env failed"
  echo %errorlevel%
  exit /b
)

echo "Print torch version"
python -c "import torch; print(torch.__version__)"

pushd functorch
echo "Install functorch"
python setup.py develop
popd
if ERRORLEVEL 1 goto fail

echo "Test functorch"
pushd test
python run_test.py --functorch --shard "%SHARD_NUMBER%" "%NUM_TEST_SHARDS%" --verbose
popd
if ERRORLEVEL 1 goto fail

:eof
exit /b 0

:fail
exit /b 1
