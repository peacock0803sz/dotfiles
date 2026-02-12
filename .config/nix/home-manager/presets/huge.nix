{ pkgs, ... }: {
  imports = [
    ./large.nix
  ];

  home.packages = with pkgs; [
    nur.repos.peacock0803sz.tfcmt

    kubectl
    terraform
    kustomize
    tflint
    tflint-plugins.tflint-ruleset-google

    act
    awscli2
    # firebase-tools
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.alpha
      google-cloud-sdk.components.beta
      google-cloud-sdk.components.cloud-datastore-emulator
      google-cloud-sdk.components.cloud-firestore-emulator
      # google-cloud-sdk.components.cloud-spanner-emulator
      google-cloud-sdk.components.cloud-run-proxy
      google-cloud-sdk.components.cloud-sql-proxy
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.log-streaming
      google-cloud-sdk.components.pubsub-emulator
    ])
  ];
}
