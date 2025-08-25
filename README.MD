# NeoHoods Space Helm Chart

## Overview


## Chart Configuration

### PostgreSQL

- **Enabled**: `false` (PostgreSQL is not deployed by default)
- **Persistence**:
  - **Enabled**: `true`
  - **Size**: `10Gi`

### Backend

- **Enabled**: `false` (Backend is not deployed by default)
- **Image**:
  - **Repository**: `ghcr.io/neohoods/space-platform-api`
  - **Tag**: `latest`
- **Replica Count**: `2`
- **Service**:
  - **Type**: `LoadBalancer`
  - **Port**: `8080`
- **Environment Variables**:
  - `DB_HOST`: `postgresql.platform.svc.cluster.local`
  - `DB_USER`: `neohoods_user`
  - `DB_NAME`: `neohoods`

### Frontend

- **Enabled**: `true` (Frontend is deployed by default)
- **Image**:
  - **Repository**: `ghcr.io/neohoods/space-platform-ui`
  - **Tag**: `latest`
- **Replica Count**: `1`
- **Service**:
  - **Type**: `LoadBalancer`
  - **Port**: `8080`
- **Environment Variables**:
  - `API_URL`: `https://space.neohoods.com/api`

### Ingress

- **Host**: `space.neohoods.com`
- **Cert Manager Cluster Issuer**: `letsencrypt-prod`
- **Secret Name**: `letsencrypt-platform`

## Installation

To install the NeoHoods Helm chart, use the following command:

```bash
helm install my-neohoods-space ./neohoods-space-helm/charts/neohoods-space
```

You can customize the installation by overriding the default values in `values.yaml` using the `--set` flag or by providing a custom `values.yaml` file.

## Usage

After installation, the frontend service will be accessible via the specified ingress host `space.neohoods.com`. Ensure that your DNS is configured to point to the ingress controller's external IP.

## Contributing

Contributions to the neohoods Helm chart are welcome! Please open an issue or submit a pull request with your improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact

For any questions or support, please contact [your email address].
