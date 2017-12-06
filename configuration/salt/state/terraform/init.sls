install_terraform:
  archive.extracted:
    - name: /bin/
    - source: https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip
    - source_hash: 4e3d5e4c6a267e31e9f95d4c1b00f5a7be5a319698f0370825b459cb786e2f35
    - archive_format: zip
    - enforce_toplevel: False