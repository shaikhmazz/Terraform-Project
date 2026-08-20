# 🚀 Terraform + Jenkins: Automated AWS Infrastructure Pipeline

> Push code → Jenkins wakes up → Terraform plans your infra → you hit approve → AWS builds it.
> No manual `terraform apply` on your laptop, ever again.

![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?logo=terraform&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?logo=jenkins&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazonaws&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-Webhook_Triggered-181717?logo=github&logoColor=white)

---

## 🧭 What this actually does

This repo turns a `git push` into a fully automated, human-approved AWS deployment.

```
Developer  →  GitHub  →  Webhook  →  Jenkins  →  Terraform  →  AWS
```

No SSH-ing in to run commands. No "did I remember to `terraform plan` first?" No secrets sitting in a `.tf` file. Just code, a review gate, and infrastructure that shows up exactly as planned.

---

## 🏗️ Architecture

```
┌───────────┐   git push    ┌────────────┐   webhook   ┌──────────────┐
│ Developer │ ────────────▶ │   GitHub   │ ──────────▶ │   Jenkins    │
└───────────┘                └────────────┘             └──────┬───────┘
                                                                 │
                              ┌──────────────────────────────────┼──────────────────────────────┐
                              ▼                                  ▼                                ▼
                        terraform init               terraform fmt + validate              terraform plan
                                                                 │
                                                                 ▼
                                                        🖐  Manual Approval
                                                                 │
                                                                 ▼
                                                        terraform apply
                                                                 │
                              ┌──────────────────────────────────┴──────────────────────────────┐
                              ▼                                                                    ▼
                     ┌─────────────────┐                                              ┌────────────────────┐
                     │   AWS (VPC)     │                                              │  S3 Remote State   │
                     └─────────────────┘                                              └────────────────────┘
```

**Why the manual approval gate matters:** Terraform can apply infrastructure changes instantly and irreversibly. This pipeline forces a human to read the plan before anything touches AWS — the same discipline real production pipelines use.

---

## 🧰 Stack

| Layer | Tool |
|---|---|
| Source control | GitHub |
| CI/CD orchestration | Jenkins (Pipeline as Code) |
| Infrastructure as Code | Terraform |
| Cloud provider | AWS |
| Remote state | Amazon S3 |

---

## 📁 Project Structure

```
terraform-jenkins-project/
│
├── provider.tf
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── .gitignore
├── Jenkinsfile
├── README.md
│
└── modules/
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

The root module doesn't define resources directly — it calls the reusable `modules/vpc` module, which is what actually provisions the VPC, subnet(s), Internet Gateway, and route table.

---

## ⚙️ Pipeline Stages

| # | Stage | What happens |
|---|---|---|
| 1 | **Checkout** | Jenkins pulls the latest commit from GitHub |
| 2 | **Terraform Init** | Initializes the working directory + S3 backend |
| 3 | **Format Check** | `terraform fmt -check` — fails fast on messy code |
| 4 | **Validate** | `terraform validate` — catches config errors before planning |
| 5 | **Plan** | `terraform plan` — shows exactly what will change |
| 6 | **Manual Approval** | Pipeline pauses. A human reviews the plan and clicks Approve or Abort |
| 7 | **Apply** | `terraform apply` — only runs after approval |

The whole thing is triggered by a **GitHub webhook** on every push — nobody clicks "Build Now."

---

## 🖥️ How to Run This Yourself

### 1. Provision the backend
Create an S3 bucket first — Terraform needs it to store state before you can even `init`.

### 2. Configure & test locally (once)
```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply   # first-time verification only
terraform output
```

### 3. Push to GitHub
```bash
git add .
git commit -m "Initial infrastructure setup"
git push
```

### 4. Wire up Jenkins
- Install Jenkins + Git + Terraform + AWS CLI on the box
- Add AWS credentials in **Jenkins → Credentials** (ID: `aws-creds`)
- Create a Pipeline job pointing at this repo's `Jenkinsfile`
- Add a GitHub webhook pointing at `http://<jenkins-host>:8080/github-webhook/`

### 5. Make a change and watch it fly
```bash
git add .
git commit -m "Update infrastructure configuration"
git push
```
GitHub notifies Jenkins → Jenkins runs the pipeline → you approve → AWS updates. That's the whole loop.

---

## 🔐 Security Notes

- ✅ AWS credentials live only in Jenkins Credentials — never in code
- ✅ `.terraform/` and `*.tfstate*` are gitignored — state never touches GitHub
- ✅ IAM permissions scoped to only what the pipeline needs
- ✅ Every apply requires a human to look at the plan first

---

## 🧹 Cleanup

Tearing down is just as controlled as standing up — a separate destroy workflow ([`Jenkinsfile.destroy`](file:///c:/Users/HP/Desktop/terraform/Jenkinsfile.destroy)) with its own manual approval gate before `terraform destroy` runs.


---

## ✅ Success Criteria

If you can change a Terraform variable, push it, watch Jenkins pick it up automatically, review the plan, approve it, and see AWS reflect that change — with the state safely sitting in S3 the whole time — this project is doing its job.

**GitHub → Jenkins → Terraform → AWS.**