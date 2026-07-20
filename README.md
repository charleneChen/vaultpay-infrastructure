# VaultPay Infrastructure

## Issues Occurred
### Issue 1
- I launched temporary EC2 instances through AWS Console to verify all three network tiers.
- After completing the verification, I terminated the instances but forgot to delete the security group.
- Then run `terraform destroy` to clean up. However, deleting the VPC failed.
```
Error: deleting EC2 VPC (vpc-0a7c6957b0800d319): operation error EC2: DeleteVpc, https response error StatusCode: 400, RequestID: 4b3d4935-8888-45d3-8377-99e84c4ab071, api error DependencyViolation: The vpc 'vpc-0a7c6957b0800d319' has dependencies and cannot be deleted.
```

- I have to delete the EC2 Security Group manually through the AWS Console. Then run `terraform destroy` again. 
- Now, the VPC can be deleted successfully. `terraform destroy` run successfully.
