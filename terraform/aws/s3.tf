# ==========================================
# 1. DATA BUCKET
# ==========================================
resource "aws_s3_bucket" "data" {
  bucket        = "${local.resource_prefix.value}-data"
  force_destroy = true
  tags = merge({
    Name        = "${local.resource_prefix.value}-data"
    Environment = local.resource_prefix.value
    }, {
    git_commit           = "4d57f83ca4d3a78a44fb36d1dcf0d23983fa44f5"
    git_file             = "terraform/aws/s3.tf"
    git_last_modified_at = "2022-05-18 07:08:06"
    git_last_modified_by = "nimrod@bridgecrew.io"
    git_modifiers        = "34870196+LironElbaz/nimrod/nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "0874007d-903a-4b4c-945f-c9c233e13243"
    # checkov:skip=CKV_AWS_144: "Cross-region replication is not required for lab environments"
  })
}

resource "aws_s3_bucket_versioning" "data_versioning" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_encryption" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "data_public_block" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "data_logging" {
  bucket        = aws_s3_bucket.data.id
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "data-log/"
}

resource "aws_s3_bucket_lifecycle_configuration_v2" "data_lifecycle" {
  bucket = aws_s3_bucket.data.id
  rule {
    id     = "complete-lifecycle-rule"
    status = "Enabled"
    filter {}
    expiration {
      days = 365
    }
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# ==========================================
# 2. CUSTOMER MASTER OBJECT
# ==========================================
resource "aws_s3_bucket_object" "data_object" {
  bucket     = aws_s3_bucket.data.id
  key        = "customer-master.xlsx"
  source     = "resources/customer-master.xlsx"
  kms_key_id = aws_kms_key.logs_key.arn
  tags = merge({
    Name        = "${local.resource_prefix.value}-customer-master"
    Environment = local.resource_prefix.value
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/s3.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "a7f01cc7-63c2-41a8-8555-6665e5e39a64"
  })
}

# ==========================================
# 3. FINANCIALS BUCKET
# ==========================================
resource "aws_s3_bucket" "financials" {
  bucket        = "${local.resource_prefix.value}-financials"
  force_destroy = true
  tags = merge({
    Name        = "${local.resource_prefix.value}-financials"
    Environment = local.resource_prefix.value
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/s3.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "0e012640-b597-4e5d-9378-d4b584aea913"
    # checkov:skip=CKV_AWS_144: "Cross-region replication is not required for lab environments"
  })
}

resource "aws_s3_bucket_versioning" "financials_versioning" {
  bucket = aws_s3_bucket.financials.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "financials_encryption" {
  bucket = aws_s3_bucket.financials.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "financials_public_block" {
  bucket                  = aws_s3_bucket.financials.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "financials_logging" {
  bucket        = aws_s3_bucket.financials.id
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "financials-log/"
}

resource "aws_s3_bucket_lifecycle_configuration_v2" "financials_lifecycle" {
  bucket = aws_s3_bucket.financials.id
  rule {
    id     = "complete-lifecycle-rule"
    status = "Enabled"
    filter {}
    expiration {
      days = 365
    }
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# ==========================================
# 4. OPERATIONS BUCKET
# ==========================================
resource "aws_s3_bucket" "operations" {
  bucket        = "${local.resource_prefix.value}-operations"
  force_destroy = true
  tags = merge({
    Name        = "${local.resource_prefix.value}-operations"
    Environment = local.resource_prefix.value
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/s3.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "29efcf7b-22a8-4bd6-8e14-1f55b3a2d743"
    # checkov:skip=CKV_AWS_144: "Cross-region replication is not required for lab environments"
  })
}

resource "aws_s3_bucket_versioning" "operations_versioning" {
  bucket = aws_s3_bucket.operations.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "operations_encryption" {
  bucket = aws_s3_bucket.operations.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "operations_public_block" {
  bucket                  = aws_s3_bucket.operations.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "operations_logging" {
  bucket        = aws_s3_bucket.operations.id
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "operations-log/"
}

resource "aws_s3_bucket_lifecycle_configuration_v2" "operations_lifecycle" {
  bucket = aws_s3_bucket.operations.id
  rule {
    id     = "complete-lifecycle-rule"
    status = "Enabled"
    filter {}
    expiration {
      days = 365
    }
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# ==========================================
# 5. DATA SCIENCE BUCKET
# ==========================================
resource "aws_s3_bucket" "data_science" {
  bucket        = "${local.resource_prefix.value}-data-science"
  force_destroy = true
  tags = merge({}, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/s3.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "9a7c8788-5655-4708-bbc3-64ead9847f64"
    # checkov:skip=CKV_AWS_144: "Cross-region replication is not required for lab environments"
  })
}

resource "aws_s3_bucket_versioning" "data_science_versioning" {
  bucket = aws_s3_bucket.data_science.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_science_encryption" {
  bucket = aws_s3_bucket.data_science.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "data_science_public_block" {
  bucket                  = aws_s3_bucket.data_science.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "data_science_logging" {
  bucket        = aws_s3_bucket.data_science.id
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "data-science-log/"
}

resource "aws_s3_bucket_lifecycle_configuration_v2" "data_science_lifecycle" {
  bucket = aws_s3_bucket.data_science.id
  rule {
    id     = "complete-lifecycle-rule"
    status = "Enabled"
    filter {}
    expiration {
      days = 365
    }
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# ==========================================
# 6. LOGS BUCKET
# ==========================================
resource "aws_s3_bucket" "logs" {
  bucket        = "${local.resource_prefix.value}-logs"
  force_destroy = true
  tags = merge({
    Name        = "${local.resource_prefix.value}-logs"
    Environment = local.resource_prefix.value
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/s3.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "01946fe9-aae2-4c99-a975-e9b0d3a4696c"
    # checkov:skip=CKV_AWS_144: "Cross-region replication is not required for lab environments"
  })
}

resource "aws_s3_bucket_versioning" "logs_versioning" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs_encryption" {
  bucket = aws_s3_bucket.logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.logs_key.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logs_public_block" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration_v2" "logs_lifecycle" {
  bucket = aws_s3_bucket.logs.id
  rule {
    id     = "complete-lifecycle-rule"
    status = "Enabled"
    filter {}
    expiration {
      days = 365
    }
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}
