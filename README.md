# Digital Ocean Kubernetes Infra

This project is a Terraform-based infrastructure deployment targeting **Digital Ocean**. It demonstrates best practices in infrastructure as code (IaC) and deploys a production-ready Kubernetes cluster with enhanced features using **Helm charts**.

## Features

This cluster is designed for production use and comes pre-configured with the following enhancements:

### 1. **Load Balancers**
   - Automatically provisions and integrates load balancers for seamless traffic management.
   - Configured for high availability and scalability to handle production traffic.

### 2. **Monitoring and Alerting**
   - Includes **Prometheus** and **Grafana** for real-time monitoring and observability.
   - Pre-configured alerts for critical metrics like CPU, memory, and disk usage.

### 3. **Logging**
   - Centralized logging using **ELK (Elasticsearch, Logstash, Kibana)** stack or **Loki**.
   - Simplifies troubleshooting by aggregating logs from all nodes and pods.

### 4. **Ingress Controller**
   - Deploys a production-grade ingress controller using **NGINX**.
   - Supports HTTPS termination and routing rules for multiple applications.

### 5. **Automatic Certificate Management**
   - Integrated **cert-manager** for managing SSL/TLS certificates.
   - Automates certificate issuance and renewal for HTTPS endpoints.

### 6. **Scaling**
   - Configures **Horizontal Pod Autoscalers (HPA)** for application workloads.
   - Node autoscaling for optimizing resource usage and costs.

### 7. **Security**
   - Network policies for isolating workloads.
   - Role-Based Access Control (RBAC) to secure cluster operations.

## Folder Structure

```
infra/
├── .github/           # CI/CD workflows for automating infrastructure deployments
├── k8s/               # Kubernetes Helm charts and configurations
├── main.tf            # Main Terraform configuration file
├── variables.tf       # Input variable definitions
├── providers.tf       # Provider configurations
├── data.tf            # Data source configurations
├── locals.tf          # Local variables for reusable values
├── env.tfvars         # Environment-specific variable values
├── outputs.tf         # Output definitions for key resources
├── .gitignore         # Files and folders to be ignored by Git
└── README.md          # Project documentation
```

## Prerequisites

- **Terraform**: Ensure Terraform is installed on your machine. [Download Terraform](https://www.terraform.io/downloads.html)
- **Digital Ocean Account**: An active account for managing resources.
- **kubectl**: Required to interact with the Kubernetes cluster.
- **Helm**: Used for managing Kubernetes applications.

## Usage

1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd infra
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Plan the infrastructure changes:
   ```bash
   terraform plan -var-file=env.tfvars
   ```

4. Apply the changes to deploy resources:
   ```bash
   terraform apply -var-file=env.tfvars
   ```

5. Configure `kubectl` for the new cluster:
   ```bash
   doctl kubernetes cluster kubeconfig save <cluster_name>
   ```

6. Deploy Helm charts:
   ```bash
   helm repo add <chart_repo> <repo_url>
   helm install <chart_name> <repo_url/chart_name>
   ```

## CI/CD Integration

The project includes GitHub Actions workflows (located in `.github/`) to automate infrastructure deployment. These workflows ensure consistent application of Terraform configurations and integration with Kubernetes.

## Customization

- Update `variables.tf` to modify input variables based on your requirements.
- Modify `env.tfvars` for environment-specific values.
- Add or modify Helm charts in the `k8s/` directory to include additional features.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any feature requests or improvements.

## License

This project is licensed under the [MIT License](LICENSE).

---

This repository showcases a production-ready Kubernetes setup with advanced features and Terraform integration. For questions or assistance, feel free to reach out.
