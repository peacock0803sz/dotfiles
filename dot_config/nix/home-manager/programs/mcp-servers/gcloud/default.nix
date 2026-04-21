{ pkgs }: {
  command = "${pkgs.lib.getExe' pkgs.nodejs "npx"}";
  args = [ "-y" "@google-cloud/gcloud-mcp" ];
  env = {
    "CLOUDSDK_AUTH_IMPERSONATE_SERVICE_ACCOUNT" = "gcloud-readonly@gx-mcp-gateway.iam.gserviceaccount.com";
  };
}
