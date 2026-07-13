---
name: image-edit-director
description: Create strict, low-freedom image editing prompts for Lovart, Nano Banana Pro, and similar image models. Use when the user needs stable prompts for garment replacement, replacing a person into a scene, preserving identity, pose, background, clothing details, accessories, props, face clarity, or preventing models from mixing image roles.
---

# Image Edit Director

Use this skill to write image-editing prompt contracts. Do not edit images directly unless the user separately asks for generation or editing. Prioritize stable image-role separation over creative language.

## Production Goal

Build scene-matched prompt packages, not generic rules and not one-off patches. The reusable part is the analysis method; the final wording must be customized to the current scene image, reference image, garment, person count, pose, camera angle, and failure risks.

Always optimize for:

- reading the current scene before writing the prompt
- naming the actual people, poses, garments, props, and background elements visible in the scene
- separating what the scene image controls from what each reference image controls
- choosing the fastest combined prompt that still matches the scene
- attaching targeted repair prompts for only the high-risk parts

Do not output generic boilerplate like "replace all people" or "keep the background". Name the actual targets and background items in the user's image.

## Scene-Matched Prompt Package Contract

For each task, first perform a task-local scene analysis, then output a prompt package:

1. `Mode`: selected mode and why.
2. `Scene inventory`: concrete visible background, props, lighting, camera angle, people count, poses, and occlusions.
3. `Reference inventory`: concrete visible face, garment, front/back view, accessories, graphics, fabric, and props provided by each reference image.
4. `Target map`: each target person or garment region with a stable label tied to the current scene.
5. `Main prompt`: the fastest combined prompt customized to this scene.
6. `Repair prompts`: short prompts for the highest-risk targets in this scene.
7. `Checklist`: what to inspect after generation for this exact scene.

The main prompt should be copy-ready and scene-specific. The repair prompts should be optional and only used if the main prompt fails in a specific area.

When the task is simple, keep the package short. When the task has multiple people, multiple garments, visible faces, front/back references, props, or complex poses, include the full scene inventory and target map.

## Batch Scene Workflow

Use this workflow when the user provides many scene images after the single-scene workflow is mature.

Do not reuse one generic prompt across all scenes. For every scene image:

- inspect the actual scene structure
- count the visible people
- label every target person by position, pose, orientation, and occlusion
- identify visible faces, back-facing bodies, seated bodies, standing bodies, hands, props, and scene contact points
- identify the exact background elements that must be preserved
- choose the correct reference source for each target
- write a scene-specific main prompt
- write only the repair prompts that match the risks in that scene

When asked to organize outputs into a folder, create one folder per batch and use this structure:

```text
batch-name/
  00-index.md
  scene-001/
    source-note.md
    main-prompt.txt
    target-map.md
    repair-prompts.md
    checklist.md
  scene-002/
    source-note.md
    main-prompt.txt
    target-map.md
    repair-prompts.md
    checklist.md
```

`00-index.md` must summarize every scene with its filename, mode, people count, highest-risk target, and recommended first repair if the batch prompt fails.

`main-prompt.txt` must be ready to paste into the user's image tool.

`target-map.md` must describe the scene-specific target labels, not generic labels.

`repair-prompts.md` must include targeted repair prompts only for likely failure points such as visible faces, seated figures, hands, front/back garment graphics, complex accessories, or occluded bodies.

`checklist.md` must be specific to the scene and should not be a generic quality checklist.

If the user provides a naming convention, follow it. Otherwise, use `scene-001`, `scene-002`, etc. Preserve the original filename in `source-note.md`.

## Core Rules

Classify the request before writing any prompt. Select exactly one mode:

- `garment-replacement`: replace only the clothing on the base person.
- `person-to-scene-replacement`: replace the scene person with the reference person.

If the user asks for both, split the work into separate passes. Do not combine garment replacement and person replacement in one prompt unless the user explicitly accepts higher risk.

Treat image roles as hard constraints:

- The base image controls everything except the allowed edit area.
- The reference image contributes only the object defined by the selected mode.
- Do not import unrelated identity, body, pose, background, lighting, or styling from the wrong image.
- Do not ask the image model to reason, reinterpret, redesign, beautify, or fill in missing details. In the final prompt, explicitly instruct it to execute the listed constraints literally.

Default to Chinese output unless the user asks for another language. Keep the final prompt direct, repetitive where needed, and copy-ready.

## Required Output Structure

Always output these sections:

1. `模式判断`
2. `图片角色`
3. `只允许修改`
4. `必须保留`
5. `必须继承`
6. `禁止项`
7. `质量验收`
8. `最终提示词`

Include assumptions only when image roles are not labeled clearly. If role ambiguity would make the result unsafe, ask one short question before producing the final prompt.

## Universal Execution Block

Include this idea in every final prompt:

```text
严格按以下编辑约束执行。不要自由发挥，不要重新设计，不要根据审美改图，不要添加未提到的新元素，不要自动补全缺失内容，不要把参考图中未被指定继承的内容带入结果。当信息冲突时，以“只允许修改”“必须保留”“必须继承”“禁止项”的约束为最高优先级。
```

Do not claim this can disable the model's internal reasoning. It only reduces creative freedom through hard constraints.

## Mode: garment-replacement

Use when the user wants to replace clothing on an existing person, including full outfit replacement, upper garment replacement, lower garment replacement, dress replacement, coat replacement, uniform replacement, fabric/pattern transfer, or product-clothing try-on.

Image roles:

- Base image: final person, face, hair, skin, body proportion, pose, gesture, expression, background, camera angle, lighting, shadow, and composition.
- Garment reference image: clothing source only. It must not provide identity, face, hair, body, pose, gesture, expression, background, or camera angle.

Allowed edit area:

- Edit only the specified garment area on the base person.
- Include necessary garment edges, sleeves, collar, hem, waistband, and natural cloth folds.
- Preserve skin, face, hair, hands, legs, body shape, accessories, background, and scene objects unless the user explicitly says they are part of the garment replacement.

Must inherit from garment reference:

- Garment category and full silhouette.
- Fit, cut, length, layering, collar/neckline, shoulders, sleeves, cuffs, waist, hem, closures, pockets, seams, straps, buttons, zippers, drawstrings, labels, logo, print, pattern, embroidery, texture, fabric, color, material finish, and visible construction details.
- If a logo, print, stripe, plaid, graphic, or repeated pattern exists, state that it is a core garment detail and must remain visible, complete, aligned to fabric folds, and not simplified.

Fit and realism requirements:

- Adapt the reference garment to the base person's body, pose, and camera perspective.
- Make the garment wrap naturally around the torso, arms, waist, hips, or legs as applicable.
- Match the base image lighting, shadow direction, color temperature, sharpness, lens perspective, and occlusion by hands, hair, bags, jewelry, or other foreground elements.

Garment production protocol:

- Start with a garment target map when more than one garment or more than one person is involved.
- Label each garment region, such as `front upper T-shirt`, `back upper T-shirt`, `pants`, `shoes`, or `outer layer`.
- State whether each reference is a front view, back view, side view, flat-lay, product photo, or model-worn photo.
- Preserve the base person's pose, anatomy, face, hands, and scene.
- Do not allow a garment reference model to contribute identity, pose, face, hairstyle, body, or background.
- Treat logos, typography, graphic prints, embroidery, patches, texture wash, seams, tags, collar shape, sleeve shape, and hem shape as core garment identity.
- If exact text in a graphic is unreliable for the model, require layout, contrast, placement, and overall graphic block integrity rather than hallucinated readable text.

Garment replacement final prompt template:

```text
模式：garment-replacement

严格按以下编辑约束执行。不要自由发挥，不要重新设计，不要根据审美改图，不要添加未提到的新元素，不要自动补全缺失内容。

任务：
只替换底图人物身上的[指定服装/整套服装]，将其换成参考图中的服装。参考图只作为服装来源，不作为人物来源。

图片角色：
底图提供最终人物、脸部五官、发型、肤色、身材比例、姿势、手势、表情、背景、镜头角度、构图、光线和阴影。
参考图只提供服装本身，包括版型、颜色、面料、图案、Logo、结构和细节。

只允许修改：
只允许修改底图人物身上的服装区域。不要修改脸、五官、头发、皮肤、手、腿、身体比例、姿势、手势、表情、配饰、背景、光线或构图。

必须保留：
完整保留底图人物身份、脸部五官、发型、肤色、身材比例、姿势、手势、表情、背景、镜头角度、构图、光线方向、阴影关系和画面清晰度。

必须继承：
严格继承参考服装的整体类别、版型、剪裁、长短、松紧、领口、肩线、袖型、袖口、腰线、下摆、叠穿关系、纽扣、拉链、口袋、缝线、抽绳、标签、Logo、印花、图案、纹理、颜色、面料质感和所有可见结构细节。Logo、印花、条纹、格纹、图案和装饰属于服装核心细节，必须完整保留，不能消失、简化、错位或变形。

贴合要求：
新服装必须自然贴合底图人物身体和姿势，符合人体结构、布料褶皱、透视、遮挡关系和原图光影。服装边缘要自然，不能像贴纸，不能漂浮，不能改变人物身体。

禁止项：
不要换脸。不要改变底图人物五官。不要继承参考图人物的脸、头发、身体、姿势、手势、表情或背景。不要改变底图背景。不要改变人物比例。不要模糊脸部。不要增加面部噪点。不要让服装图案、Logo、口袋、纽扣、拉链、缝线或结构细节消失。

质量验收：
人物脸部必须和底图一致且清晰自然；服装细节清楚；图案完整；边缘干净；光影统一；画面保持高清、低噪点、真实自然。
```

## Mode: person-to-scene-replacement

Use when the user wants to place a reference person into a scene, replace a person in a scene, swap the model, replace identity, preserve a scene while changing the person, or inherit a reference person's face, clothing, accessories, props, action, gesture, or expression.

Image roles:

- Scene image: final background, environment, composition, camera angle, lighting, color temperature, shadow, spatial perspective, target person location, and object relationships.
- Person reference image: person source. It provides identity, face, facial features, hairstyle, skin tone, body traits, clothing, shoes, accessories, props, and visible styling.

Pose policy:

- State pose policy explicitly in every prompt.
- If the user says to keep the scene pose, preserve the original scene person's pose, gesture, body orientation, and location while replacing identity and appearance.
- If the user says to inherit the reference pose, action, gesture, or expression, transfer those from the reference person and adapt them to the scene perspective.
- If the user does not specify pose, default to preserving the scene person's location and broad body pose, while using the reference person's identity, face, clothing, accessories, and props.

Allowed edit area:

- Edit the target person region and necessary contact shadows/reflections only.
- Preserve scene background, camera, perspective, lighting, and nearby objects.

Must inherit from person reference:

- Face shape, facial features, identity, hairstyle, hair color, skin tone, body traits, clothing, shoes, bags, jewelry, glasses, hat, scarf, watch, handheld props, other visible accessories, and expression when requested.
- Enumerate visible accessories and props when the user provides them. Do not use generic "accessories" alone if details are known.

## Multi-Person Scene Protocol

Use this protocol whenever a scene contains more than one target person. Do not write a single generic "replace all people" prompt for a multi-person scene.

Require a target map before the final prompt:

- Assign each scene person a stable label by position and pose, such as `left back-facing man`, `center standing woman`, `front seated woman`, or `right back-facing man`.
- Assign exactly one reference source to each scene person.
- State whether the reference source provides a front view, back view, side view, or only outfit details.
- State which scene pose must be preserved for each target person.
- State which face source applies to each visible face. If the target face is visible, "scene face retention" must be explicitly set to `0%`.

For best stability, recommend one edit pass per target person when the model supports masks or regional editing:

1. Replace the most important visible face first.
2. Replace the next visible face.
3. Replace back-facing people last, using back-view garment references.

If the user insists on one combined prompt, include the target map inside the prompt and warn that it is less stable than target-by-target editing.

Never let a front-view studio reference overwrite a scene pose. The scene controls pose and body action; the reference controls identity, face, outfit, accessories, and garment graphics only.

## Efficient Multi-Person Output

For production efficiency, do not only recommend one-person-at-a-time editing. Output a prompt package:

1. `Main batch prompt`: one combined prompt with a strict target map, fixed person count, fixed scene poses, and per-target reference sources.
2. `Target repair prompts`: short optional repair prompts for each visible face or high-risk target.
3. `Failure diagnosis`: tell the user which target to repair first if the batch result fails.

The main batch prompt must include these hard constraints:

- Keep the exact same number of people as the scene image.
- Do not add new people, duplicate people, remove people, or merge people.
- Each target person keeps the scene position, pose, gesture, body direction, and contact relationship.
- Each visible target face has `scene face retention = 0%`.
- Back-facing targets use back-view references and should not grow visible faces.
- Front-facing targets use front-view references for identity and face.
- Reference studio poses are forbidden unless explicitly requested.

Use target-by-target editing as a fallback, not as the default final answer, unless the user is already in a repair pass or requests maximum reliability over speed.

Person-to-scene final prompt template:

```text
模式：person-to-scene-replacement

严格按以下编辑约束执行。不要自由发挥，不要重新设计，不要根据审美改图，不要添加未提到的新元素，不要自动补全缺失内容。

任务：
将场景图中的目标人物替换为参考图中的人物。场景图是最终画面的基础，参考图是人物来源。

图片角色：
场景图提供最终背景、环境、构图、镜头角度、空间透视、光线方向、阴影、色温、人物所在位置和人与场景物体的关系。
参考图提供要替换进去的人物身份、脸型、五官、发型、肤色、身材特征、服装、鞋子、包、首饰、眼镜、帽子、手持道具和其他可见配饰。

姿势策略：
[保留场景图原人物的位置和大姿势 / 继承参考图的动作、姿势、手势和表情，并适配到场景透视中]。

只允许修改：
只允许修改场景图中的目标人物区域，以及人物与地面或物体接触产生的必要阴影和反射。不要修改背景、建筑、家具、道路、天空、灯光、镜头角度或构图。

必须保留：
完整保留场景图的背景、环境、构图、镜头角度、空间透视、光线方向、阴影关系、色温、清晰度和人物所在位置。

必须继承：
严格继承参考人物的身份、脸型、五官比例、发型、发色、肤色、身材特征、服装、鞋子、包、首饰、眼镜、帽子、手表、手持道具和所有可见配饰。参考人物的配饰和道具必须完整出现，不能丢失、简化或替换成场景图原人物的物品。

融合要求：
参考人物必须自然融入场景，匹配场景图的光线、阴影、透视、清晰度、色温、镜头焦段和空间尺度。人物边缘自然，接触阴影合理，不能像贴上去。

禁止项：
不要保留场景图原人物的脸、五官、身份、衣服、鞋子、配饰或道具。不要改变场景背景。不要丢失参考人物的脸部特征、配饰、道具、服装细节。不要让脸部模糊。不要增加面部噪点。不要让五官漂移。不要产生多余手指、扭曲手部、身体比例异常或衣服图案变形。

质量验收：
替换后人物必须是参考图人物；脸部清晰自然；五官稳定；皮肤纹理干净；配饰和道具完整；人物与场景光影一致；画面高清、低噪点、真实自然。
```

## Failure Repair Rules

When the user reports a bad result, diagnose by failure type and strengthen only the relevant constraints:

- Face did not transfer in `person-to-scene-replacement`: state that the scene person's original identity has zero retention and only provides location/pose if requested.
- Base person changed in `garment-replacement`: state that the garment reference is clothing-only and all reference-person traits are forbidden.
- Garment logo, pattern, or structure disappeared: enumerate the missing details as core garment construction that must be preserved.
- Accessories or props disappeared: list each visible item individually and state that generic accessory preservation is insufficient.
- Pose is wrong: explicitly set the pose policy to scene-pose or reference-pose.
- Image became blurry or noisy: add face-level and garment-level sharpness checks, but do not add vague quality words without restating preservation rules.
- Hands are distorted: state the exact hand policy: preserve base hands for garment replacement; inherit or preserve hands according to the pose policy for person replacement.

Do not fix failures by making the prompt more decorative. Fix failures by narrowing roles, edit areas, inheritance rules, and forbidden changes.
