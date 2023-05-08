# terraform-google-firewall-rule

이 모듈은 [terraform-google-module-template](https://stash.wemakeprice.com/users/lswoo/repos/terraoform-google-module-template/browse)에 의해서 생성되었습니다. 

The resources that this module will create are:

- Create firewall rules with the provided name

## Usage

모듈의 기본적인 사용법은 다음과 같습니다:

```hcl
module "firewall_rule" {
  source = "git::https://stash.wemakeprice.com/scm/tgm/terraform-google-firewall-rule.git"

  project_id         = "my-prod-project"
  network            = "my-prod-network"
  config_directories =[
    "./prod",
    "./common"
  ]

  log_config  = {
    metadata = "EXCLUDE_ALL_METADATA" 
  }
}
}
```

모듈 사용의 예시는 [examples](./examples/) 디렉토리에 있습니다.

## Rule definition format and structure
Firewall rule configuration은 폴더 내에 yaml 파일의 형태로 위치해야 합니다. Firewall 규칙 구조는 다음과 같습니다.

```
rule-name: # firewall 규칙 이름. module에 의해 naming convention이 조정됩니다.
  allow:  # `allow` 혹은 `deny`
  - ports: ['443', '80'] # 특정 protocol에 대한 ports, 모든 port를 지정하려면 빈 리스트 `[]` 를 입력하세요.
    protocol: tcp # protocol, 모든 protocol을 지정하려면 `all` 을 입력하세요.
  direction: EGRESS # EGRESS 혹은 INGRESS
  disabled: false # `false` 혹은 `true`, `true`일때 firewall 규칙이 비활성화됩니다. 기본값은 `false` 입니다.
  priority: 1000 # 규칙의 우선순위 값. 기본값은 1000 입니다.
  source_ranges: # source ranges의 리스트. `INGRESS` 규칙의 경우에만 지정되어야 합니다.
  - 0.0.0.0/0
  destination_ranges: # destination ranges의 리스트. `EGRESS` 규칙의 경우에만 지정되어야 합니다.
  - 0.0.0.0/0
  source_tags: ['some-tag'] # source tag 리스트.  INGRESS` 규칙의 경우에만 지정되어야 합니다.
  source_service_accounts: # source service accounts 리스트. INGRESS` 규칙의 경우에만 지정되어야 합니다. `source_tags` 혹은 `target_tags`와 함께 지정할 수 없습니다.  
  - myapp@myproject-id.iam.gserviceaccount.com
  target_tags: ['some-tag'] # target tag 리스트.
  target_service_accounts: # target service accounts 리스트. `source_tags` 혹은 `target_tags`와 함께 지정할 수 없습니다.  
  - myapp@myproject-id.iam.gserviceaccount.com
```
Firewall rules example yaml configuration
```
# allow ingress from GCLB to all instances in the network
lb-health-checks:
  allow:
  - ports: []
    protocol: tcp
  direction: INGRESS
  priority: 1001
  source_ranges:
  - 35.191.0.0/16
  - 130.211.0.0/22

# deny all egress
deny-all:
  deny:
  - ports: []
    protocol: all
  direction: EGRESS
  priority: 65535
  destination_ranges:
  - 0.0.0.0/0

cat ./dev/team-a/web-app-a.yaml
# Myapp egress
web-app-a-egress:
  allow:
    - ports: [443]
      protocol: tcp
  direction: EGRESS
  destination_ranges:
    - 192.168.0.0/24
  target_service_accounts:
    - myapp@myproject-id.iam.gserviceaccount.com
# Myapp ingress
web-app-a-ingress:
  allow:
    - ports: [1234]
      protocol: tcp
  direction: INGRESS
  source_service_accounts:
    - frontend-sa@myproject-id.iam.gserviceaccount.com
  target_service_accounts:
    - web-app-a@myproject-id.iam.gserviceaccount.com
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| config\_directories | yaml 포맷의 firewall config 파일이 위치한 폴더 경로의 List. 파일의 접미사는 반드시 `.yaml`여야 함. | `list(string)` | n/a | yes |
| log\_config | 로그 설정. `metadata`에 들어갈 수 있는 값은 `EXCLUDE_ALL_METADATA` 와 `INCLUDE_ALL_METADATA`가 있음. firewall logging을 비활성화하려면 `null`로 설정. | <pre>object({<br>    metadata = string<br>  })</pre> | `null` | no |
| network | firewall 규칙을 적용할 네트워크명 | `string` | n/a | yes |
| project\_id | 프로젝트 ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| egress\_allow\_rules | allow 블록의 Egress 규칙 . |
| egress\_deny\_rules | deny 블록의 Egress 규칙. |
| ingress\_allow\_rules | allow 블록의 Ingress 규칙 . |
| ingress\_deny\_rules | deny 블록의 Ingress 규칙 . |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

이 모듈을 사용하기 위해 필요한 사항을 표기합니다.

### Software

아래 dependencies들이 필요합니다:

- [Terraform][terraform-provider-gcp-beta] v1.3
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v4.40.0

### Service Account

이 모듈의 리소스를 배포하기 위해서는 아래 역할이 필요합니다:

- Compute Admin: `roles/compute.admin`
- Compute Security Admin: `roles/compute.securityAdmin`

[Project Factory module][project-factory-module] 과
[IAM module][iam-module]로 필요한 역할이 부여된 서비스 어카운트를 배포할 수 있습니다.

### APIs

이 모듈의 리소스가 배포되는 프로젝트는 아래 API가 활성화되어야 합니다:

- None

[Project Factory module][project-factory-module]을 이용해 필요한 API를 활성화할 수 있습니다.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform-provider-gcp-beta]: https://www.terraform.io/downloads.html

## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).

## TO DO

- [ ] Example README 번역
