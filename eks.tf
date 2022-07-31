

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}


data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

data "aws_eks_cluster" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

################################################################
######### EKS Blueprints
################################################################

module "eks_blueprints" {
  source = "https://github.com/oebinu/terraform-aws-oebinu-print?ref=v1.0.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.21"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  managed_node_groups = {
    mg_5 = {
      node_group_name = "managed-ondemand"
      subnet_ids      = module.vpc.private_subnets
      instance_types  = ["t3.medium"]

      desired_size = 3
      max_size     = 10
      min_size     = 3
      k8s_labels   = {"role" = "ops"}
    }
  }

  tags = local.tags

  depends_on = [
    module.vpc
  ]
}
