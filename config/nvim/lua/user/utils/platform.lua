local M = {}

M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

function M.executable(command)
  return vim.fn.executable(command) == 1
end

function M.default_windows_shell()
  if M.executable("pwsh.exe") then
    return {
      name = "pwsh.exe",
      cmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command",
    }
  end

  if M.executable("powershell.exe") then
    return {
      name = "powershell.exe",
      cmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command",
    }
  end

  if M.executable("cmd.exe") then
    return {
      name = "cmd.exe",
      cmdflag = "/s /c",
    }
  end

  return nil
end

return M
