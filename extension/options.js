// Save / restore extension settings

document.addEventListener("DOMContentLoaded", async () => {
  const stored = await chrome.storage.local.get(["driveFolderId"]);

  if (stored.driveFolderId) {
    document.getElementById("drive-folder").value = stored.driveFolderId;
  }
});

document.getElementById("btn-save").addEventListener("click", async () => {
  const driveFolderId = document.getElementById("drive-folder").value.trim();

  await chrome.storage.local.set({ driveFolderId });

  const status = document.getElementById("status");
  status.textContent = "✅ Settings saved.";
  status.className = "success";

  setTimeout(() => {
    status.textContent = "";
  }, 3000);
});
