# tech-challenge-eks

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
[![Terraform](https://img.shields.io/badge/Terraform-v1.7.5+-623CE4?logo=terraform)](https://img.shields.io/badge/Terraform-v1.0.0+-623CE4?logo=terraform)
[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-v2+-2088FF?logo=github)](https://img.shields.io/badge/GitHub%20Actions-v2+-2088FF?logo=github)

###  The repository tech-challenge-eks contains configuration files for creating an cluster EKS on AWS.

## Table of Contents
- [Table of Contents](#table-of-contents)
    - [Requirements](#requirements)
    - [Installation](#installation)
    - [Usage](#usage)
    - [Kubernetes](#kubernetes)
    - [License](#license)
    - [References](#references)

## <center> Requirements </center>

The following tools are required to run the project:


| Name      | Version   |
|-----------|-----------|
| terraform | >= 1.7.5  |
| aws       | >= 3.0    |
| kubectl   | >= 1.31.0 |
| kustomize | >= 5.4.2  |


##  <center> Installation </center>

1. Clone the repository:

```bash
git clone https://github.com/team-tech-challenge/tech-challenge-eks.git
```

2. Change to the directory:

```bash
cd tech-challenge-eks
```

3. Change to the directory project Terraform:

```bash
cd iac
```

4. Initialize Terraform:

```bash
terraform init -upgrade -backend-config="bucket=${BUCKET_NAME}" -backend-config="key=${PROJECT_NAME}/terraform.tfstate" -backend-config="region=us-east-1"
```

5. Create the Terraform plan:

```bash
terraform plan -var-file="terraform.tfvars"
```

6. Validate the Terraform plan:

```bash
terraform validate -var-file="terraform.tfvars"
```

7. Apply the Terraform plan:

### <center><mark> **WARNING**: The command will create the resources on AWS </mark>

>> ⚠️ **To execute `terraform apply`, you need to execute it in GitHub Actions.**</center>


## <center> Usage </center>

Your need install the AWS CLI and configure the credentials.

1. Download the AWS CLI:

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

2. Unzip the file:

```bash
unzip awscliv2.zip
```

3. Install the AWS CLI:

```bash
sudo ./aws/install
```

4. Configure the AWS CLI:

```bash
aws configure
```

5. Download o Kubeconfig file:

```bash
aws eks --region us-east-1 update-kubeconfig --name ${CLUSTER_NAME} --profile ${PROFILE_NAME}
```
---
## <center> Kubernetes</center>

### <center><u> Example commands to use in the management of the cluster: </u> </center>


1. Check the nodes:

```bash
kubectl get nodes
```

2. Check the pods:

```bash
kubectl get pods -A
```

3. Check the services:

```bash
kubectl get svc -A
```

4. Check the deployments:

```bash
kubectl get deployments -A
```

5. Check the namespaces:

```bash
kubectl get namespaces
```

6. Check the configmaps:

```bash
kubectl get configmaps -A
```
7. Check the secrets:

```bash
kubectl get secrets -A
```

8. Execute in the port-forward:

```bash
kubectl port-forward svc/${SERVICE_NAME} ${PORT_LOCAL}:${PORT_SERVICE} -n ${NAMESPACE}
```

9. Execute in the logs:

```bash
kubectl logs -f ${POD_NAME} -n ${NAMESPACE}
```

10. Execute in the exec:

```bash
kubectl exec -it ${POD_NAME} -n ${NAMESPACE} -- /bin/bash
```

11. Execute in the describe:

```bash
kubectl describe ${RESOURCE} ${RESOURCE_NAME} -n ${NAMESPACE}
```

---

### License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

### References

- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [Amazon EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [kubectl Documentation](https://kubernetes.io/docs/reference/kubectl/)

---