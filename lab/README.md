## Lab Solution

Move files to correct location:

- `src/docker-compose-multi-platform-tags.yml` - sets multi-platform image tags
- `cicd/push-manifest-list.ps1` - compiles and pushes manifest lists
- `.github/workflows/push-manifest-list.yaml` - manual trigger to publish manifest lists

Push to GitHub.

Trigger push-manifest-list workflow:

![](/lab/img/push-manifest-list-gha.png)

Produces multi-platform images:

![](/lab/img/multi-platform-package.png)