---
name: image-edit-director
description: Create strict, low-freedom image editing prompts for Lovart, Nano Banana Pro, and similar image models. Use when the user needs stable prompts for garment replacement, dressed-model-to-scene replacement, replacing a person into a scene, preserving or fully replacing identity, scene pose, body action, hand gestures, scene-worn accessories such as hats and sunglasses, background, clothing details, garment length, garment source priority, viewpoint-specific garment feature filtering, old garment detail removal, preventing reference/target detail migration, accessories, props, face clarity, single-image output, or preventing models from mixing image roles.
---

# Image Edit Director

Use this skill to create strict image-editing prompt packages. Do not edit images directly unless the user separately asks for image generation or image editing. The output should be a copy-ready prompt package that reduces creative freedom through clear image roles, allowed edit areas, inheritance rules, forbidden changes, repair prompts, and a checklist.

Default to Chinese output unless the user asks for another language.

## Production Goal

Create scene-specific and garment-specific prompt packages, not generic rules. Inspect the current task images before writing the final prompt. Name the actual visible person, garment, pose, background, props, accessories, camera angle, and likely failure risks.

Always optimize for:

- separating image roles
- locking what may change and what must not change
- preserving or replacing face identity according to the selected mode
- preserving garment category, silhouette, length, fit, graphic, logo, print, fabric, seams, hem, and construction details
- inheriting only garment details that are visible and valid for the target viewpoint, instead of copying front/back/side details across views
- preserving scene target pose, body action, hand gesture, head angle, and explicitly requested scene-worn accessories such as caps, hats, sunglasses, glasses, watches, or handheld props
- preventing stiff mannequin poses in scene replacement
- preventing accidental inheritance from the wrong image
- preventing old target garments, reference shoes, reference model body, flat-lay borders, or unrelated reference details from migrating into the final result
- giving short repair prompts for likely failures

Do not claim that a prompt can disable the image model's internal reasoning. Say only that the prompt should be followed literally and should not freely redesign the image.

## Mode Selection

Select exactly one mode for each prompt pass:

- `garment-replacement`: only replace clothing on the base person. Do not change the face, body, pose, accessories, lower garments, shoes, or background unless explicitly requested.
- `person-to-scene-replacement`: replace a scene person with the reference person.

If the workflow contains both clothing replacement and scene replacement, split it into two passes:

1. `garment-replacement`: put the new garment on the clean model reference and output a dressed-model reference.
2. `person-to-scene-replacement`: insert the dressed-model reference into the scene.

In pass 2, the dressed-model reference is the complete final person source. Do not reuse the flat garment reference unless the user asks for garment-detail repair.

## Required Package Structure

Every output package must include:

1. `模式判断`
2. `图片角色`
3. `只允许修改`
4. `必须保留`
5. `必须继承`
6. `贴合与融合要求`
7. `禁止项`
8. `质量验收`
9. `最终提示词`
10. `修复提示词`

For batch folders, write one prompt package per scene. Do not reuse one generic prompt for all scenes.

## Universal Execution Block

Include this meaning in every final prompt:

```text
严格按以下编辑约束执行。不要自由发挥，不要重新设计，不要根据审美改图，不要添加未提到的新元素，不要自动补全缺失内容，不要把参考图中未被指定继承的内容带入结果。当信息冲突时，以“只允许修改”“必须保留”“必须继承”“禁止项”的约束为最高优先级。
```

## Image Role Contract

Use hard role separation.

For `garment-replacement`:

- Base image provides final person identity, face, hair, skin, body proportion, pose, gesture, expression, accessories, lower garments, shoes, background, camera, lighting, shadow, and composition.
- Garment reference provides only the specified garment: category, silhouette, fit, length, collar, shoulders, sleeves, hem, fabric, color, wash, seams, labels, logo, graphic, print, typography, pattern, embroidery, pockets, closures, tags, and construction details.
- Garment reference must not provide face, hair, body, pose, gesture, expression, background, lighting, camera, or model identity.
- The old target garment in the base image provides only the replacement region boundary and body-pose fit guide. Its color, fabric, pockets, seams, zippers, logos, graphics, waistband, hem, leg shape, wash, and decorative details must not be inherited unless the user explicitly asks to keep them.

For `person-to-scene-replacement`:

- Scene image provides environment, background, camera, lighting, composition, target placement, scale, depth, occlusion, broad pose, posture, action, head angle, body lean, arm position, hand gesture, contact points, scene props, and any explicitly preserved scene-worn styling items.
- Person or dressed-model reference provides identity, full face, facial geometry, hair, skin tone, body traits, final outfit, shoes, accessories, tattoos, carried props, and styling.
- If a scene target's face is visible, set `scene face retention = 0%`.
- If using a dressed-model reference, set `scene clothing retention = 0%`.

## Garment Source Priority And Detail Migration Protocol

Use this protocol for every garment-replacement prompt, especially when the user provides flat-lay garments, front/back/side references, or target images that already contain a similar garment.

Before writing the final prompt, create a source priority map:

- `base target image`: final person, body pose, hand position, shoes, non-target clothing, accessories, background, camera, crop, lighting, shadow, and composition.
- `old target garment`: replacement area boundary and body-contact guide only. It does not provide final garment design.
- `garment reference`: the only source for the new garment's color, category, silhouette, fit, length, fabric, seams, pockets, zippers, waistband, hem, logo, print, graphic, wash, tags, and construction details.
- `unused reference content`: any reference model, shoes, upper garment, background, flat-lay canvas, white border, mannequin, crop, or product-display layout that was not explicitly named as the target garment source.

Every garment-replacement final prompt must include these hard retention values:

- `garment reference detail retention = 100%`
- `old target garment detail retention = 0%`
- `old target garment color/fabric/pocket/seam/zipper/logo/graphic/waistband/hem retention = 0%`
- `old target garment silhouette retention = 0% except body-pose fit boundary`
- `base target shoes / hands / upper garment / accessories / background retention = 100%`
- `reference shoes / reference model / reference body / reference background retention = 0%`
- `flat-lay canvas / product border / comparison layout retention = 0%`

For pants replacement, explicitly name both sides of the boundary:

- Keep from the base target: upper garment, jacket hem overlap, hand-in-pocket pose, hands, shoes, leg stance, camera crop, background, lighting, and shadow.
- Remove from the old pants: old color, old pocket shape, old side seams, old zippers, old waist construction, old hem shape, old fabric, old wrinkles, old logos, and old leg silhouette.
- Inherit from the new pants reference: new color, new waistband, new pocket layout, new side line or zipper placement, new leg volume, new fabric texture, new hem, and front/back/side details that match the target viewpoint.

If a model output keeps the old garment's color or details, diagnose it as `old garment leakage`. Repair by saying the old target garment may provide only the body-area mask and pose-fit boundary; all visible garment design details must be replaced by the garment reference.

If a model output changes shoes, hands, upper garments, background, or person identity, diagnose it as `reference non-garment leakage`. Repair by saying the garment reference provides no shoes, no body, no pose, no background, no upper garment, and no model identity; restore those areas from the base target image.

## Viewpoint Feature Gate Protocol

Use this whenever garment references include front, back, side, flat-lay, or multiple colorway images. Do not treat all garment references as one merged detail pool.

Before writing the final prompt, create a viewpoint feature map:

- `front-view allowed features`: only details visibly present on the front reference and valid on the target front view.
- `back-view allowed features`: only details visibly present on the back reference and valid on the target back view.
- `side/three-quarter allowed features`: only details that would physically sit on the visible side panel for that viewpoint.
- `global garment features`: color, fabric, broad silhouette, garment length, leg width, hem width, and fabric weight may transfer across views.
- `view-locked features`: pockets, zippers, side lines, drawstrings, fly/crotch placket, buttons, back pockets, back yoke, center seams, labels, and graphics may not transfer to a different view unless they would be physically visible there.

Every prompt must include an explicit absence list when a likely wrong feature could be invented:

- If the back reference has no side line, write: `back-view side line retention = 0%; do not add side silver lines on the back view`.
- If the front reference has no fly, zipper, button, drawstring, hanging tab, logo, or crotch decoration, write: `front crotch/fly extra detail retention = 0%; keep the front crotch area plain except natural fabric seam and folds`.
- If a side feature is only partly visible, write that it may appear only on the physically visible outer side seam, not on the center front, center back, crotch, or inner leg.

For pants replacement, use these gates:

- Front target: inherit front waistband, front pockets, front leg shape, visible side lines only if present in the front reference. Do not add back pockets, back yoke, back seams, or back-only pocket flaps.
- Back target: inherit back waistband, back pockets, back center seam, back leg shape. Do not add front pockets, front fly, front crotch placket, front drawstring, or side lines if the back reference does not show them.
- Side target: inherit only the side seam/side line if it is physically visible from the side angle. Do not duplicate side lines onto both front and back panels.

If a result adds a detail that is absent from the selected viewpoint reference, diagnose it as `cross-view detail leakage`. Repair by naming the forbidden detail and the correct view source, for example: `the back reference has no side silver line, so remove all back-view side silver lines`.

## Single-Image Output Protocol

Use this whenever the user provides multiple garment references, front/back/side flat-lay references, before/after references, or multiple target views.

Before writing the final prompt, classify each image as either:

- `garment reference`: provides only garment structure, color, fabric, construction, front details, back details, side details, pockets, seams, zippers, drawstrings, waistbands, hems, and silhouette.
- `base target image`: provides the only final composition, person count, crop, viewpoint, pose, background, lighting, shoes, hands, upper garment, and camera.

Every garment-replacement prompt must explicitly lock the output composition:

- final output must be one single image
- keep the base target image's original person count
- keep the base target image's original crop and viewpoint
- do not create a front/back comparison
- do not create a left/right comparison
- do not create a product display board
- do not add a second model
- do not duplicate the model
- do not turn flat-lay front/back references into worn front/back views

When only a front result is needed, use only the front garment reference and say the back reference is not used for this pass. When only a back result is needed, use only the back garment reference and say the front reference is not used for this pass. When a side or three-quarter result needs both references, state that front/back references provide structure only and are not composition references.

If the model generates two people, a front/back pair, or a comparison layout, repair by restating:

- the result is failed because it changed the output composition
- keep only the single base target model
- delete the extra view/model/panel
- preserve the original crop, background, pose, hands, shoes, and upper garment
- apply the garment only to the existing target garment region

## Garment-Replacement Protocol

Use this for replacing a whole garment or outfit on an existing person while preserving the base person.

### Allowed Edit Area

Only edit the target garment region and necessary garment edges:

- collar / neckline
- shoulders
- sleeves
- torso cloth
- hem
- necessary cloth folds
- garment shadow and contact around the body

Do not edit face, hair, skin, hands, body shape, pose, expression, accessories, pants, skirt, shoes, background, camera, or lighting unless explicitly included in the garment target.

### Garment Detail Lock

Treat these as core garment identity:

- garment category
- cut and fit
- exact visible length
- shoulder width
- sleeve length
- collar shape
- hem shape
- fabric weight and texture
- wash / fading / distressing
- seams / stitching / ribbing / tags / labels
- print / logo / typography / graphic / embroidery / pattern
- print scale, position, layout, contrast, and color blocks

If exact text cannot be reliably reproduced, require the layout, scale, placement, contrast, color blocks, and overall graphic structure to stay faithful. Do not let the graphic become random small text, a blurry patch, or a plain shirt.

### Garment Length And Fit Lock

Always classify and state garment length before the final prompt:

- `短版 / cropped / short-length`: hem sits around the high waist, waistband, or upper hip; it must not extend to the crotch or become a long oversized tee.
- `常规长度`: hem sits around mid-hip.
- `长版 / oversized long`: hem falls lower and covers more of the hip.
- `外套 / coat / dress`: use the visible garment-specific length.

When the user says the garment is a short version, write hard constraints:

- The garment is a short-version T-shirt.
- Preserve the short body length and short hem position from the reference.
- The hem should sit around the upper waist / waistband / upper-hip area according to the reference and base body perspective.
- Do not stretch the shirt downward.
- Do not turn it into a regular long T-shirt or oversized long tee.
- Do not cover the pants waist, crotch, side hanging cloth, belt area, or lower-garment details that should remain visible.
- If the shorter hem reveals an area previously covered by the old shirt, restore that area from the base image or keep it naturally as the original lower garment/waist area. Do not invent new skin exposure unless the reference garment clearly requires it.

For flat-lay garment references, adapt the garment proportion to the base body but keep the same short/regular/long length category. Do not let flat-lay width or empty-shirt shape override the base body anatomy.

### Garment Prompt Must Explicitly Say

- only the target garment changes
- base face retention = 100%
- base body / pose retention = 100%
- base background retention = 100%
- base non-target clothing / shoes / hands / accessories retention = 100%
- garment reference identity / body / pose / background retention = 0%
- garment reference shoes / upper garment / model / flat-lay background retention = 0%
- target garment detail retention = 100%
- old target garment detail retention = 0%
- old target garment may provide only the replacement mask, body contact, and pose-fit boundary
- final output = one single image
- base target image person count / crop / viewpoint retention = 100%
- comparison layout / front-back pair / duplicated model = forbidden

## Person-To-Scene / Dressed-Model-To-Scene Protocol

Use this when the user wants a model or already dressed model inserted into a scene.

For each target person, write a target contract:

- `scene target`: exact scene person label by position, pose, orientation, and occlusion
- `dressed-model source`: exact reference image / model label
- `pose source`: scene target only unless the user asks for reference pose
- `identity source`: dressed-model source only
- `face source`: dressed-model source only
- `hair source`: dressed-model source only
- `outfit source`: dressed-model source only
- `accessory source`: dressed-model source by default; scene target only for explicitly preserved scene-worn styling items such as cap, hat, sunglasses, glasses, watch, bracelet, or handheld prop
- `background source`: scene only
- `scene face retention = 0%`
- `scene clothing retention = 0%`

Full face replacement means replacing visible face identity, face shape, eyes, eyelids, eyebrows, nose, mouth, lips, jawline, cheekbones, skin tone, hairline, visible ears, and hairstyle boundary. The scene face may provide only head position, head scale, head direction, occlusion, and lighting adaptation.

If the reference person already wears the target clothes, treat the whole visible outfit as final: top, pants, shoes, graphics, back print, front print, wash texture, seams, labels, jewelry, chains, tattoos, keychain, hanging accessories, and carried props.

## Scene Pose And Scene-Worn Styling Protocol

Use this protocol when the user wants the reference person to replace a scene person but still keep the scene target's pose, body action, hand gesture, hat, sunglasses, glasses, or other styling items.

Do not treat every scene-worn accessory as forbidden. Some items belong to the scene target's styling and should stay even while the face, body identity, and clothing are replaced.

Before writing the final prompt, classify each visible scene item:

- `scene pose to keep`: body lean, head tilt, shoulder angle, arm lift, hand gesture, finger sign, leg stance, weight shift, foot direction, sitting/standing/crouching/leaning state, and contact with floor or props.
- `scene-worn styling to keep`: cap, hat, sunglasses, glasses, mask, gloves, watch, bracelet, ring, belt, chain, scarf, or other accessory the user says should stay from the scene target.
- `scene clothing to remove`: shirt, pants, shoes, jacket, garment graphic, garment logo, and outfit styling from the scene target when using a dressed-model reference, unless the user explicitly says to preserve them.
- `reference identity to inherit`: face, facial features, hair, skin tone, body traits, final outfit, shoes, and reference-owned accessories not overridden by scene-worn styling preservation.

When preserving scene-worn styling items, write them by name in the target map. Example:

```text
scene-worn styling preserved from target: black backward cap, transparent sunglasses
identity source: reference female model only
outfit source: reference female model only
pose source: scene male target only
```

If a scene target wears a cap or sunglasses and the user complains they disappeared, future prompts must state:

- Keep the scene target's cap/hat/sunglasses/glasses as scene-worn styling.
- Adapt those accessories onto the reference person's head and face naturally.
- Preserve the reference person's face identity underneath/around the accessory.
- Do not let the accessory change the reference identity.
- Do not remove the accessory unless the user says the reference person's own head styling should override it.

For distinctive pose transfer, do not write only "keep broad pose." Name the visible action exactly. Examples:

- `keep the torso leaning left`
- `keep the head tilted downward`
- `keep both arms raised beside the shoulders`
- `keep both hands forming the same finger gesture`
- `keep the asymmetrical streetwear stance`

The reference model's studio pose must not overwrite these scene pose details unless the user explicitly asks for reference-pose transfer.

## Natural Pose And Behavior Protocol

Use this when replaced people look stiff, line up like mannequins, stand too straight, or interact awkwardly.

For every target in a group scene, include:

- location lock: keep the target's scene position, scale, depth layer, and ground/furniture contact
- orientation lock: keep the broad facing direction: front, side, back, side-back, seated, crouching, leaning, or walking
- pose flexibility: allow only small naturalization that keeps the same composition
- weight and stance: standing targets need asymmetric weight, relaxed shoulders, non-parallel feet, or a slight knee bend
- hand ownership: every visible hand must belong to a named target
- contact owner: if a hand touches another person, name the owner and contact area
- safe contact zones: shoulder, upper arm, outer forearm, or upper back
- forbidden contact zones: face, neck, chest, waist, crotch, inner thigh, or ambiguous intimate areas

Do not solve stiffness by adding dramatic gestures. Use low-risk micro-actions only: one hand in pocket, hand resting at side, relaxed elbow bend, slight lean toward the group, head turned naturally, or hand lightly resting on shoulder/upper arm if the scene already supports that relationship.

## Multi-Person Scene Protocol

Do not write "replace all people" for a multi-person scene.

Create a target map:

- stable label for each person, such as `left back-facing man`, `center standing woman`, `front seated woman`, `right side-facing man`
- exact reference source for each target
- which targets have visible faces
- which targets need front-view, side-view, or back-view reference
- which scene pose / action / contact must remain
- which accessories and props belong to the reference versus the scene

The main combined prompt must include:

- keep the same number of people as the scene image
- do not add, duplicate, remove, or merge people
- each target keeps scene position, scale, broad pose, body direction, and contact relationship
- each visible target face has `scene face retention = 0%`
- each target's scene clothing has `scene clothing retention = 0%`
- reference studio poses are forbidden unless explicitly requested

Use target-by-target repair prompts when the combined prompt fails.

## Repair Rules

Diagnose the failure and strengthen only the relevant constraint:

- face did not transfer: full visible head/face/hair identity must come from the assigned reference; scene face retention is `0%`
- face blended: partial blending is failure; preserve only scene head angle, scale, lighting, and occlusion
- garment length wrong: restate the exact length category, hem location, and forbidden length extension
- garment graphic missing: enumerate the graphic/logo/print as core garment identity
- garment became plain: require print scale, layout, color blocks, and graphic structure from reference
- old garment leakage: old target garment color, pockets, zippers, seams, waistband, hem, graphics, fabric, and silhouette were incorrectly retained; old target garment retention must be `0%` except for replacement mask and body-pose fit boundary
- reference non-garment leakage: reference shoes, reference model body, reference upper garment, flat-lay background, product border, or reference crop were incorrectly inherited; garment reference must provide only the target garment while base target shoes, hands, upper garment, accessories, background, crop, and lighting remain `100%`
- cross-view detail leakage: a front/back/side-only detail was copied into the wrong viewpoint; remove details not visible in the selected viewpoint reference and keep only physically valid details for the target camera angle
- base person changed in garment replacement: garment reference is clothing-only; base identity/body/pose/background retention is `100%`
- output became two views or two models: final output must be one single image; keep the base target image's original person count, crop, viewpoint, background, pose, hands, shoes, and upper garment; delete any front/back pair, comparison panel, second model, duplicated model, or product display layout
- dressed-model outfit did not transfer: scene clothing retention is `0%`; dressed-model outfit retention is `100%`
- accessories disappeared: list each accessory separately; generic "accessories" is insufficient
- pose stiff: keep location and broad orientation, but allow only small naturalized shoulders, weight, feet, knees, head angle, and hand placement
- scene pose missing: restate the exact scene pose elements to keep, including body lean, head tilt, arm lift, hand gesture, finger sign, leg stance, and weight shift; forbid importing the reference studio pose
- scene-worn accessory missing: restate the exact accessory names to preserve from the scene target, such as black backward cap and transparent sunglasses; adapt them onto the reference person while preserving the reference face and outfit
- behavior inappropriate: name hand owner and move unclear hands to side, pocket, or safe contact zones
- image blurry/noisy: require face-level and garment-level sharpness while preserving the same edit constraints

Do not fix failures by making the prompt more decorative. Fix them by narrowing roles, allowed edit areas, inheritance rules, and forbidden changes.

## Copy-Ready Garment Prompt Skeleton

Use this skeleton after filling in task-specific image details:

```text
模式：garment-replacement

严格按以下编辑约束执行。不要自由发挥，不要重新设计，不要根据审美改图，不要添加未提到的新元素，不要自动补全缺失内容。只执行服装替换。

任务：只替换底图人物身上的[目标服装区域]，替换成服装参考图中的[目标服装]。参考图只作为服装来源，不作为人物来源。

图片角色：底图提供最终人物身份、脸部五官、发型、肤色、身材比例、姿势、手势、表情、非目标服装、鞋子、配饰、背景、镜头角度、构图、光线和阴影。服装参考图只提供目标服装本身，包括类别、版型、衣长、领口、肩线、袖型、下摆、面料、颜色、图案、Logo、文字、印花、结构和细节。

来源优先级：底图优先提供人物、姿势、手、鞋、非目标服装、配饰、背景、光线、阴影、构图和裁切；旧目标服装只提供替换区域边界、身体贴合关系和姿势透视，不提供最终服装设计；服装参考图是新服装唯一来源；参考图中非目标服装、鞋子、人物、身体、姿势、背景、白底、商品图边界和展示构图继承率为 0%。

细节迁移锁定：target garment detail retention = 100%；old target garment detail retention = 0%；old target garment color/fabric/pocket/seam/zipper/logo/graphic/waistband/hem retention = 0%；base shoes / hands / non-target clothing / accessories / background retention = 100%；reference shoes / reference model / reference body / reference background retention = 0%。

视角细节过滤：[列出当前目标视角：正面/背面/侧面/斜侧]。只继承该视角参考图中真实可见、并且物理上会出现在当前镜头角度的服装细节。正面细节不得搬到背面，背面细节不得搬到正面，侧边细节只能出现在可见外侧裤片/衣片。对参考图中没有出现但模型容易脑补的细节，必须明确写入禁止项。

只允许修改：[目标服装区域]。不允许修改脸、五官、头发、皮肤、手、腿、身体比例、姿势、手势、表情、配饰、非目标服装、鞋子、背景、光线或构图。

必须保留：完整保留底图人物身份、脸部五官、发型、肤色、身体比例、姿势、手势、表情、配饰、非目标服装、鞋子、背景、镜头角度、构图、光线方向、阴影关系和画面清晰度。

必须继承：严格继承参考服装的类别、版型、剪裁、衣长、松紧、领口、肩线、袖型、袖口、下摆、面料质感、颜色、洗水质感、缝线、标签、Logo、文字、印花、图案、图案比例、图案位置、图案颜色层次和当前视角真实可见的结构细节。

衣长锁定：[写明短版/常规/长版，以及衣摆落点]。不要把衣服拉长，不要改变成其他衣长。

贴合要求：新服装必须自然贴合底图人物身体和姿势，符合人体结构、布料褶皱、透视、遮挡关系和原图光影。图案必须跟随布料曲面和褶皱，不漂浮、不像贴纸、不越界。

禁止项：不要换脸，不要改五官，不要改发型，不要改肤色，不要改身体比例，不要改姿势或表情，不要改背景，不要让服装图案消失、简化、错位、变形，不要保留旧目标服装的颜色、口袋、缝线、拉链、腰头、裤脚、Logo、图案、面料或版型，不要把参考图的人物、鞋子、上衣、背景、平铺白底或商品图边界带入结果，不要新增当前视角参考图中不存在的拉链、纽扣、抽绳、挂件、标签、门襟、侧线、口袋、装饰或图案。

质量验收：最终图必须仍然是底图人物本人；只有目标服装被替换；服装版型、衣长、图案、Logo、面料和边缘自然清晰；背景和光影保持底图一致；画面高清、低噪点、真实自然。
```

## Copy-Ready Person-To-Scene Prompt Skeleton

Use this skeleton after filling in target map details:

```text
模式：person-to-scene-replacement

严格按以下编辑约束执行。不要自由发挥，不要重新设计，不要根据审美改图，不要添加未提到的新元素，不要自动补全缺失内容。

任务：将场景图中的[目标人物]替换为参考图中的[参考人物/已穿好目标服装的模特]。

图片角色：场景图提供最终背景、环境、构图、镜头角度、空间透视、光线方向、阴影、色温、人物位置、人物比例、大姿势、动作、手势、接触关系和场景道具。参考图提供要替换进去的人物身份、完整脸部五官、发型、肤色、身体特征、当前完整服装、鞋子、配饰、纹身、挂件、手持道具和造型细节。

目标映射：[逐个列出场景目标、参考来源、姿势来源、脸部来源、服装来源、配饰来源。可见脸必须写 scene face retention = 0%。使用已穿好服装的模特时必须写 scene clothing retention = 0%。]

必须保留：完整保留场景图背景、环境、构图、镜头、空间透视、光线、阴影、色温、清晰度、人物位置、人物比例、前后层级、遮挡关系、接触点和场景道具。

必须继承：完整继承参考人物的脸型、五官结构、眼睛、眉毛、鼻子、嘴型、下颌线、肤色、皮肤质感、发型、发际线、头发长度、当前完整服装、鞋子、图案、Logo、正面图案、背面图案、面料、洗水质感、缝线、标签、项链、耳环、戒指、手链、手表、纹身、挂件和明确携带的道具。

姿势策略：保留场景目标的位置、比例、大朝向、坐/站/靠/蹲状态和接触关系；只允许小幅自然化肩膀、重心、脚位、膝盖、头部角度、手部落点，避免站桩。不要把参考图棚拍站姿带入场景。

禁止项：不要保留场景原人物的脸、五官、身份、服装、鞋子或配饰。不要混合场景原脸和参考脸。不要新增人物、删除人物、复制人物或合并人物。不要改变背景。不要产生来源不明的手、悬空手、穿模手或不合适触碰。

质量验收：替换后人物必须是参考图人物；脸部清晰稳定；服装、图案、鞋子、配饰完整；人物与场景光影、透视和接触阴影一致；姿势自然不站桩；画面高清、低噪点、真实自然。
```
