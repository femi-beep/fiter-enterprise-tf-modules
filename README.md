# Fiter-enterprise-tf-modules

This repo contains Remote Terraform Modules which will be used to set up Fiter / Clients Infrastructure. Migrated from fineract enterprises infra with some additional improvements
- Managing of Client Environments from one Source. supports internal and external clients
- Supports versioning of Modules, Allowing Upgrade of Different environments without affecting each other
- Security Improvements
  - Private EKS Cluster
  - EKS endpoint restriction
- Support for GP3 drives in eks
- Added Karpenter Autoscaler Support e.t.c

## Folder Structure

- Each module contains `main.tf`, `outputs.tf` and `variables.tf` even if they are empty as minimal configuration setup.
- Each module shall contain a `README.md` in Markdown style to explain the function of the module, the prerequisites and any other necessary information.
- All variables and outputs should have descriptions.

* Example:

```
    $ tree minimal-module/
    ├── README.md
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
```