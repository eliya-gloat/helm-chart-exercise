# helm-chart-exercise

Shared Helm charts for platform services.

| Chart                 | Purpose                                                                                                 |
| --------------------- | ------------------------------------------------------------------------------------------------------- |
| `charts/devops_infra` | Base chart every service depends on: Deployment, Service, and the `<appName>-common-env-vars` ConfigMap |

## Consuming

Charts are published to the Helm repository at `https://eliya-gloat.github.io/helm-chart-exercise`
(the `gh-pages` branch of this repo). Apps declare it as a dependency:

```yaml
dependencies:
  - name: devops_infra
    version: ^1.15.0
    repository: https://eliya-gloat.github.io/helm-chart-exercise
```

A change here reaches an app only after a new chart version is published **and** the app's version
constraint admits it. A branch of this repo is not resolvable by `helm dependency update`.

## Values contract

All shared settings are read from `global.*`, so the parent chart and this subchart see the same values:

| Key                      | Meaning                                                     |
| ------------------------ | ----------------------------------------------------------- |
| `global.appName`         | Names every rendered object                                 |
| `global.envType`         | `dev` or `prod`                                             |
| `global.region`          | Short region: `euc1`, `apse1`                               |
| `global.cloudProvider`   | `aws` (default) or `azure`                                  |
| `global.namespacePrefix` | Prepended to namespaces when resolving in-cluster addresses |

Subchart values (under `devops_infra:` in the app):

| Key                   | Meaning                                              |
| --------------------- | ---------------------------------------------------- |
| `deployment.extraEnv` | List of `{name, value}`, rendered as container `env` |
| `service.create`      | Render a Service (default `true`)                    |

## Environment precedence

The container mounts, in order:

1. `envFrom` → `<appName>-common-env-vars` (rendered by this chart)
2. `envFrom` → `<appName>-env-vars` (rendered by the app)
3. `env` → `deployment.extraEnv`

For a key defined more than once, the later source wins; explicit `env` beats every `envFrom`.
