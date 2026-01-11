#!/bin/bash
terraform -chdir=../terraform output -raw app_ip
