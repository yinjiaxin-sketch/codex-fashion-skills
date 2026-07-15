---
name: image-edit-director
description: Create strict, low-freedom image editing prompts for Lovart, Nano Banana Pro, and similar image models. Use when the user needs stable prompts for garment replacement, dressed-model-to-scene replacement, replacing a person into a scene, preserving or fully replacing identity, pose, background, clothing details, accessories, props, face clarity, or preventing models from mixing image roles.
---

# Image Edit Director

Use this skill to write image-editing prompt contracts. Do not edit images directly unless the user separately asks for generation or editing. Prioritize stable image-role separation over creative language.

## Production Goal

Build scene-matched prompt packages, not generic rules and not one-off patches. The reusable part is the analysis method; the final wording must be customized to the current scene image, reference image, garment, person count, pose, camera angle, and failure risks.

Always optimize for:

- reading the current scene before writing the prompt
- naming the actual people, poses, garments, props, and background elements visible in the scene
- separating what the scene image controls from what each reference image controls
- recognizing whether the person reference is a raw model, a garment reference, or a dressed model already wearing the target outfit
- preventing stiff mannequin poses, awkward social behavior, and unclear hand ownership after replacement
- choosing the fastest combined prompt that still matches the scene
- attaching targeted repair prompts for only the high-risk parts

Do not output generic boilerplate like "replace all people" or "keep the background". Name the actual targets and background items in the user's image.

## Two-Stage Fashion Workflow

Use this workflow when the user first puts a changing garment onto a model, then inserts that dressed model into a scene.

Split the work into two separate prompt passes:

1. `garment-replacement`: apply the new garment to the clean model reference. Output a dressed-model reference.
2. `person-to-scene-replacement`: insert the dressed-model reference into the scene.

In pass 2, the dressed-model reference is the complete final person source. It provides identity, full face, facial features, hair, skin tone, body traits, final outfit, garment graphics, shoes, jewelry, accessories, tattoos, props, and styling. The scene image provides only background, camera, lighting, composition, target location, target pose, body direction, contact points, occlusion, and shadows.

Do not use the original garment reference again in pass 2 unless the user explicitly asks for garment-detail repair. Do not let the scene person's original clothing survive in pass 2. For every target in pass 2, set:

- `scene face retention = 0%`
- `scene clothing retention = 0%`
- `dressed-model face / hair / outfit / accessories retention = 100%`

If the user provides models wearing different clothes, treat each provided dressed-model image as the final appearance source for that target. Do not assume the garment color, graphic, logo, or accessory from an earlier task still applies.

## Image Role Inheritance Contract

For every person-to-scene or dressed-model-to-scene prompt, write a concrete inheritance split. Do not use vague role text.

The model or dressed-model reference provides:

- `identity`: person identity, face shape, facial geometry, eyes, eyelids, eyebrows, nose, mouth, lips, jawline, cheekbones, ears when visible, skin tone, and facial texture.
- `hair`: hairstyle, hairline, hair color, hair length, braids, curls, bangs, volume, parting, and visible hair accessories.
- `body traits`: body build, shoulder width, neck length, limb proportions, visible tattoos, skin details, and overall styling attitude.
- `final outfit`: all current clothing on the model, including top, bottom, outer layer, shoes, socks, belt, garment fit, silhouette, length, fabric, color, wash texture, seams, labels, patches, front graphics, back graphics, typography, logos, embroidery, prints, and pattern placement.
- `person-worn accessories`: necklace, pendant, earrings, rings, bracelets, watch, glasses, hat, scarf, chain, waist chain, keychain, hanging accessory, and any accessory attached to the body or clothes.
- `person-carried props`: bag, phone, drink, book, skateboard, toy, handheld prop, or any prop physically held or worn by the model reference, if the user wants that prop transferred.
- `face expression source`: default to the model reference's facial identity and expression style, adapted only enough to match the scene head angle, gaze direction, lighting, and occlusion.

The scene reference provides:

- `environment`: background, room, street, landscape, architecture, wall, floor, ceiling, furniture, vehicle, plants, signage, painting, lamp, window, door, pool, bench, sofa, props, and all non-person scene objects.
- `camera`: final composition, crop, aspect ratio, camera height, lens perspective, depth, focal length feel, distance, and framing.
- `lighting`: light direction, color temperature, flash, shadow shape, contrast, reflections, grain, sharpness, and overall photo style.
- `target placement`: each target person's location, scale, depth layer, foreground/background order, occlusion, crop, ground contact, and distance to other people or objects.
- `pose / posture / action`: each target person's broad pose, body direction, head direction, sitting/standing/crouching/leaning state, arm position, hand gesture, leg placement, weight direction, contact with furniture or ground, and social interaction layout.
- `scene props and environmental objects`: objects not worn or carried by the model, such as chairs, sofas, flowers, candles, doors, walls, signs, umbrellas, benches, toys in the set, and large set decorations.

Accessory and prop ownership rules:

- If an item is worn on the model's body or attached to model clothing, it follows the model reference.
- If an item is held by the model reference and should appear with that person, it follows the model reference.
- If an item belongs to the scene set, furniture, architecture, background, or another non-target person, it follows the scene reference.
- If the scene target is holding a scene prop that must remain, explicitly say the scene prop is preserved and the replaced hand must grip it naturally.
- If ownership is ambiguous, write a decision in the target map before the final prompt. Do not let the image model decide.

Hard non-mixing rules:

- Scene original face retention is always `0%` for visible target faces.
- Scene original clothing retention is always `0%` when using a dressed-model reference.
- The model reference's studio pose is not inherited unless the user explicitly requests reference-pose transfer.
- Scene background, scene camera, scene lighting, and scene environmental props are not inherited from the model reference.
- Person-worn accessories and final outfit are not inherited from the scene target unless the user explicitly asks to preserve them.

## Scene-Matched Prompt Package Contract

For each task, first perform a task-local scene analysis, then output a prompt package:

1. `Mode`: selected mode and why.
2. `Scene inventory`: concrete visible background, props, lighting, camera angle, people count, poses, and occlusions.
3. `Reference inventory`: concrete reference role for each image: raw model, garment-only reference, or dressed-model final appearance reference; include visible face, garment, front/back view, accessories, graphics, fabric, and props.
4. `Role ownership inventory`: list which faces, clothes, accessories, props, poses, actions, and scene objects come from the model reference versus the scene reference.
5. `Target map`: each target person or garment region with a stable label tied to the current scene.
6. `Main prompt`: the fastest combined prompt customized to this scene.
7. `Repair prompts`: short prompts for the highest-risk targets in this scene.
8. `Checklist`: what to inspect after generation for this exact scene.

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

If the user asks for both, split the work into separate passes. Do not combine garment replacement and person replacement in one prompt unless the user explicitly accepts higher risk. If the user says the model image already wears the target clothes, skip garment transfer in the scene prompt and treat that image as a dressed-model reference.

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
- If the result tends to become stiff or "standing like a mannequin", preserve the scene target's location, scale, orientation, and contact points, but allow small pose naturalization: relaxed shoulders, slight weight shift, small knee bend, natural head angle, natural hand placement, and plausible spacing between bodies. Do not import the studio reference pose.

Allowed edit area:

- Edit the target person region and necessary contact shadows/reflections only.
- Preserve scene background, camera, perspective, lighting, and nearby objects.

Must inherit from person reference:

- Face shape, facial features, identity, hairstyle, hair color, skin tone, body traits, clothing, shoes, bags, jewelry, glasses, hat, scarf, watch, handheld props, other visible accessories, and expression when requested.
- Enumerate visible accessories and props when the user provides them. Do not use generic "accessories" alone if details are known.
- If the person reference is already wearing the target clothes, treat the whole visible outfit as final: garment category, silhouette, color, fabric, graphic, logo, print, front/back design, labels, seams, wash texture, shoes, jewelry, tattoos, and props must transfer together with the face and identity.

## Dressed-Model-To-Scene Protocol

Use this protocol whenever the reference person is already wearing the target outfit.

For each target person, write a target contract:

- `scene target`: exact scene person label by position, pose, orientation, and occlusion
- `dressed-model source`: exact reference image or model label
- `pose source`: scene target only
- `identity source`: dressed-model source only
- `face source`: dressed-model source only
- `hair source`: dressed-model source only
- `outfit source`: dressed-model source only
- `accessory source`: dressed-model source only
- `background source`: scene only
- `scene face retention = 0%`
- `scene clothing retention = 0%`

Full face replacement means replacing the visible face identity, facial geometry, eyes, eyelids, eyebrows, nose, mouth, jawline, cheekbones, skin tone, hairline, ears when visible, and hairstyle boundary. The scene face may provide only head location, head scale, head direction, occlusion, and lighting adaptation. Do not blend scene facial features with the reference face.

When a visible face fails, repair it with a face-lock pass before changing clothes again. Mask the full visible head region including face, hairline, ears, and neck edge if needed. Keep body, outfit, hands, background, pose, and lighting unchanged.

When clothing fails in pass 2, repair the target person's whole visible clothing region from the dressed-model source. Do not use the scene person's original shirt, pants, shoes, logo, print, or accessories. If the dressed-model source has a large back graphic, front graphic, skull graphic, typography, logo, wash texture, stripe, patch, chain, pendant, ring, tattoo, or hanging accessory, treat it as intentional and preserve it unless the user says it is wrong.

## Natural Pose And Behavior Protocol

Use this protocol when replaced people look stiff, line up like mannequins, stand too straight, face walls unnaturally, or create awkward social contact.

For every target person in a group scene, include a behavior contract:

- `location lock`: keep the target's scene position, scale, ground contact, and scene layer.
- `orientation lock`: keep the target's broad facing direction: front, side, back, side-back, seated, crouching, leaning, or walking.
- `pose flexibility`: allow only small natural adjustments that improve realism without changing the scene composition.
- `weight and stance`: require asymmetric weight, relaxed shoulders, non-parallel feet, or slight knee bend when the target is standing.
- `hand ownership`: every visible hand must belong to a named target. Do not create unowned hands.
- `contact owner`: if a hand touches another person, name whose hand it is and where it touches.
- `safe contact zones`: shoulder, upper arm, outer forearm, or upper back only, unless the original scene clearly shows another safe contact.
- `forbidden contact zones`: face, neck, chest, waist, crotch, inner thigh, or any ambiguous intimate area.
- `social plausibility`: keep a casual editorial group behavior; avoid grabbing, restraining, pushing, awkward hovering hands, or hands passing through bodies.

Do not solve stiffness by adding dramatic gestures. Use low-risk micro-actions: one hand in pocket, hand resting naturally at side, relaxed elbow bend, slight lean toward the group, head turned toward another person, or hand resting lightly on a shoulder or upper arm when appropriate.

When the scene has an existing interaction, preserve its intent but clean up the anatomy and contact. Example: if a scene person has an arm across another person's shoulder, keep it as a casual shoulder rest only if the hand origin is clear and the hand lands on shoulder or upper arm. Otherwise move the hand to the owner's side, pocket, or a clearly visible safe contact zone.

When the scene does not show a clear original interaction, do not invent intimate touch. Keep spacing natural and editorial.

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
- Each standing target must avoid mannequin stiffness: require relaxed shoulders, slight weight shift, natural hand placement, and non-identical stance unless the scene intentionally shows a rigid lineup.
- Every hand must have a named owner and a plausible contact target. Remove or neutralize unclear, floating, or socially awkward hands.
- Each visible target face has `scene face retention = 0%`.
- Each target person's scene clothing has `scene clothing retention = 0%` when using dressed-model references.
- Each target person's full visible outfit, shoes, graphics, accessories, tattoos, and props come from the assigned dressed-model reference.
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
如果参考图中的人物已经穿好目标衣服，则该参考图是“已穿好目标衣服的模特图”，它同时提供最终脸部身份、发型、服装、图案、鞋子、配饰、纹身和道具。场景图原人物的脸和衣服都不能保留。

继承分工：
模特参考图必须继承：完整人物身份、脸型、五官结构、眼睛、眉毛、鼻子、嘴型、下颌线、肤色、皮肤质感、发型、发际线、发色、身材特征、当前完整服装、上衣、下装、外套、鞋子、袜子、腰带、服装版型、颜色、面料、正面图案、背面图案、Logo、文字、印花、刺绣、标签、缝线、水洗质感、项链、吊坠、耳环、戒指、手链、手表、眼镜、帽子、腰链、挂件、纹身、包和明确由模特携带的手持道具。
场景参考图必须继承：背景、场地、墙面、地面、门窗、家具、建筑、植物、车辆、画作、灯具、道具陈设、构图、画幅、镜头角度、空间透视、人物位置、人物比例、前后层次、遮挡关系、光线方向、色温、阴影、照片质感、人物原始大姿势、pose、动作、手势、身体朝向、头部朝向、坐站蹲靠状态、腿部位置、与地面/家具/道具的接触关系和多人互动布局。
配饰道具归属：戴在模特身上或挂在模特衣服上的配饰跟模特参考图走；模特手里拿着且需要转移的物品跟模特参考图走；属于场景陈设、家具、建筑、背景或非目标人物的道具跟场景参考图走；如果场景目标手里原本拿着必须保留的场景道具，要明确写“保留该场景道具，并让替换后的手自然握住它”。

姿势策略：
[保留场景图原人物的位置和大姿势 / 继承参考图的动作、姿势、手势和表情，并适配到场景透视中]。
如果替换后人物容易站桩，保留场景人物的位置、画面比例、大朝向、前后层次和接触点，但允许小幅自然化姿态：肩膀放松、重心偏向一侧、脚位不完全平行、膝盖轻微弯曲、头部有自然角度、手部自然落在身体侧边/口袋/安全接触区域。不要把参考图棚拍站姿带入场景。

只允许修改：
只允许修改场景图中的目标人物区域，以及人物与地面或物体接触产生的必要阴影和反射。不要修改背景、建筑、家具、道路、天空、灯光、镜头角度或构图。

必须保留：
完整保留场景图的背景、环境、构图、镜头角度、空间透视、光线方向、阴影关系、色温、清晰度和人物所在位置。

必须继承：
严格继承参考人物的身份、脸型、五官比例、发型、发色、肤色、身材特征、服装、鞋子、包、首饰、眼镜、帽子、手表、手持道具和所有可见配饰。参考人物的配饰和道具必须完整出现，不能丢失、简化或替换成场景图原人物的物品。
可见脸目标：scene face retention = 0%。完整替换可见脸部身份、五官结构、眼睛、眉毛、鼻子、嘴型、下颌线、脸型、肤色、发际线、耳朵和发型边界。场景原脸只提供头部位置、头部大小、朝向、遮挡和光线适配，不能贡献任何五官。
服装目标：scene clothing retention = 0%。完整继承参考人物当前穿着的衣服、裤子、鞋子、图案、Logo、印花、背面图案、正面图案、面料、水洗质感、缝线、标签、链条、挂件、首饰、纹身和其他可见细节。不要保留场景原人物的衣服颜色、版型、图案或配饰。

融合要求：
参考人物必须自然融入场景，匹配场景图的光线、阴影、透视、清晰度、色温、镜头焦段和空间尺度。人物边缘自然，接触阴影合理，不能像贴上去。
多人行为必须自然合理。每只可见手都必须属于明确人物；如果手接触别人，只允许自然轻放在肩膀、上臂、外侧前臂或上背部。不要出现抓脖子、碰脸、压胸、摸腰、贴胯、穿模、悬空手、来源不明的手或像被控制/拉扯的姿势。

禁止项：
不要保留场景图原人物的脸、五官、身份、衣服、鞋子、配饰或道具。不要把场景原脸和参考脸混合。不要只换发型不换五官。不要只换衣服不换脸。不要只换脸不换衣服。不要改变场景背景。不要丢失参考人物的脸部特征、配饰、道具、服装细节。不要把参考衣服简化成普通纯色T恤。不要让脸部模糊。不要增加面部噪点。不要让五官漂移。不要产生多余手指、扭曲手部、身体比例异常或衣服图案变形。不要让所有人物站成僵硬直线。不要让站姿人物双脚完全平行、双臂僵直、肩膀耸紧、眼神空洞。不要生成不合适触碰、来源不明的手、悬空手、穿过身体的手或像抓住/限制他人的动作。

质量验收：
替换后人物必须是参考图人物；脸部清晰自然；五官稳定；皮肤纹理干净；配饰和道具完整；人物与场景光影一致；画面高清、低噪点、真实自然。
```

## Failure Repair Rules

When the user reports a bad result, diagnose by failure type and strengthen only the relevant constraints:

- Face did not transfer in `person-to-scene-replacement`: state that the scene person's original identity has zero retention and only provides location/pose if requested.
- Face only partially transferred: state that partial blending is a failure; replace the full visible head/face/hair identity from the assigned reference while preserving only scene head angle, scale, occlusion, and lighting.
- Base person changed in `garment-replacement`: state that the garment reference is clothing-only and all reference-person traits are forbidden.
- Garment logo, pattern, or structure disappeared: enumerate the missing details as core garment construction that must be preserved.
- Dressed-model outfit did not transfer in `person-to-scene-replacement`: state that scene clothing retention is zero; the assigned dressed-model reference provides the whole visible outfit, including shirt, pants, shoes, graphics, logos, front/back prints, wash texture, jewelry, chains, tattoos, and props.
- Accessories or props disappeared: list each visible item individually and state that generic accessory preservation is insufficient.
- Pose is wrong: explicitly set the pose policy to scene-pose, reference-pose, or scene-location-with-naturalized-micro-pose. Use the third option when the person is in the right place but looks stiff.
- Person looks stiff or stands like a mannequin: preserve identity, outfit, background, location, scale, and broad orientation; only adjust shoulders, weight shift, feet angle, knees, head angle, arm relaxation, and hand placement into a casual scene-appropriate pose.
- Behavior or touching is inappropriate: identify the owner of every hand, keep only safe casual contact on shoulder, upper arm, outer forearm, or upper back, and move unclear or awkward hands to the owner's side, pocket, or a neutral visible position.
- Image became blurry or noisy: add face-level and garment-level sharpness checks, but do not add vague quality words without restating preservation rules.
- Hands are distorted: state the exact hand policy: preserve base hands for garment replacement; inherit or preserve hands according to the pose policy for person replacement.

Do not fix failures by making the prompt more decorative. Fix failures by narrowing roles, edit areas, inheritance rules, and forbidden changes.
