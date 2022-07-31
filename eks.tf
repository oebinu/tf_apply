
################################################################
######### EKS Blueprints
################################################################

module "eks_blueprints" {
  source = "../.."

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
}
