# image-edit-director

Codex skill for producing scene-specific image editing prompts for:

- garment replacement: replace only clothing while preserving the original person and scene
- person-to-scene replacement: place reference people into scene images while preserving each scene's pose, background, lighting, and composition
- batch scene prompt packaging: generate one prompt folder per scene image with `main-prompt.txt`, `target-map.md`, `repair-prompts.md`, and `checklist.md`

The skill is designed for Lovart, Nano Banana Pro, and similar image editing models where role confusion, face drift, pose collapse, missing accessories, blurry faces, or garment graphic distortion can happen.

## Repository Structure

```text
skills/
  image-edit-director/
    SKILL.md
    agents/
      openai.yaml
scripts/
  install.ps1
README.md
```

## Install On Windows

Clone this repository, then run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

The script installs the skill to:

```text
%USERPROFILE%\.codex\skills\image-edit-director
```

Restart Codex after installation if the skill does not appear immediately.

## Manual Install

Copy:

```text
skills\image-edit-director
```

to:

```text
%USERPROFILE%\.codex\skills\image-edit-director
```

## Usage

Use this wording in Codex:

```text
用 image-edit-director 处理这个任务文件夹，为每张场景图输出精准替换提示词文件夹。
```

Recommended task folder layout:

```text
任务文件夹/
  场景图/
  人物参考/
  服装参考/
  配饰参考/
  要求说明.txt
```

For batch jobs, the skill should generate scene-specific prompt folders rather than one generic prompt reused across all scenes.
