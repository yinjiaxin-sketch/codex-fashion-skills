# Universal Garment Replacement Prompt Director

## When to use this skill

Use this skill when the user needs prompts for clothing replacement, scene replacement, product video prompts, reference video analysis, prompt QA, red-team checking, or multi-model prompt adaptation.

This skill is designed for fashion, ecommerce, product ads, image editing, image-to-video, and video-generation workflows.

Use it especially when the user needs to:
- replace clothing while preserving the original person
- match a reference garment automatically
- match color, wash, fabric, texture, logo, print, text, pattern, length, and fit
- preserve garment structure and silhouette
- prevent distorted graphics
- reduce noise, grain, banding, scanline texture, and over-sharpening
- adapt prompts for NanoBanana-like editors or other image/video models

## Core principle

The user should not have to manually describe every garment detail.

When a reference garment is provided, analyze it automatically and extract:
- exact perceived color and color temperature
- fabric type
- surface texture
- wash, fading, dyeing, distressing, coating, or finish
- garment length
- sleeve length, pant length, skirt length, hem position
- fit
- silhouette
- proportions
- structure
- drape
- stiffness
- thickness
- pattern, logo, text, print, stripe, check, embroidery, or graphic
- seams, stitching, buttons, zippers, pockets, collar, cuffs, waistband, hem, trims, hardware, and edges
- natural fold behavior and material behavior

If an attribute is unclear, infer it from the reference image instead of inventing a new style. Prioritize visual matching over creative reinterpretation.

## Workflow

Always work in this order:

1. Product lock
2. Reference garment or reference video analysis
3. Edit target
4. Prompt draft
5. Prompt QA / red-team check
6. Model-specific adapter
7. Repair prompts

Do not write the final prompt before the locked elements and edit target are clear.

## Product Lock

Identify what must stay unchanged:
- original person identity
- face
- hair
- body shape
- pose
- hands
- skin tone
- camera angle
- composition
- lighting direction
- shadows
- background, unless the user asks to replace it
- product proportions
- original non-target garments or accessories

Identify what may change:
- target garment
- garment color
- fabric
- texture
- wash or finish
- pattern/logo/text/graphic
- garment length
- sleeve length
- pant length
- skirt length
- fit
- silhouette
- scene or background
- lighting mood, only if requested

## Reference Garment Analysis

When the user provides a reference garment image, automatically analyze:

### Color
- exact perceived color
- color temperature: warm, cool, neutral
- saturation
- brightness
- faded or deep tone
- uneven dyeing or color variation

### Fabric And Texture
- fabric type
- weave or knit pattern
- matte, glossy, brushed, fuzzy, coated, raw, washed, ribbed, twill, fleece, satin, leather, wool, cotton, denim, canvas, mesh, nylon, or knit
- thickness
- stiffness
- stretch
- drape
- wrinkle behavior

### Wash Or Finish
- stone wash
- acid wash
- enzyme wash
- raw denim
- garment dyed
- sun faded
- vintage fade
- distressed
- coated
- waxed
- dirty wash
- clean wash
- whiskering
- seam fading
- knee fading
- thigh fading
- edge fading

### Length And Fit
- cropped
- waist-length
- hip-length
- longline
- thigh-length
- full-length
- sleeve length
- pant length
- skirt length
- hem position
- slim
- regular
- relaxed
- oversized
- boxy
- fitted
- loose
- tapered
- straight
- wide-leg

### Silhouette And Structure
- shoulder width
- waist shape
- hem width
- sleeve volume
- pant leg shape
- skirt shape
- collar size
- pocket size
- cuff width
- button spacing
- zipper length
- waistband height
- soft
- rigid
- structured
- draped
- padded
- lightweight
- heavyweight

### Details
- seams
- folds
- stitching
- buttons
- zippers
- pockets
- collar
- cuffs
- waistband
- hem
- trims
- hardware
- edges

### Pattern / Logo / Text / Graphic
For logos, text, prints, stripes, checks, embroidery, and repeated patterns, preserve:
- exact shape
- exact spelling
- scale
- placement
- spacing
- orientation
- color
- edge sharpness
- relationship to folds, seams, and garment boundaries

Use this rule:
"Preserve the original pattern/logo/text exactly. Keep the pattern scale, placement, orientation, spacing, color, and edge sharpness unchanged. Do not warp, stretch, melt, duplicate, blur, crop, or reinterpret the graphic. The printed design may follow natural fabric folds, but it must remain recognizable and proportionally accurate."

## Reference Video Analyzer

When the user provides a reference video, screenshot, or link, analyze:
- shot type
- camera angle
- camera distance
- camera movement
- subject movement
- product visibility
- lighting direction
- contrast
- color palette
- background style
- texture visibility
- fabric behavior
- motion speed
- edit rhythm
- noise, grain, compression, banding, or scanline artifacts
- risk points for product distortion

Separate:
- what to copy from the reference
- what not to copy
- what must remain from the user's original product or person

Never say only "make it like this reference." Convert the reference into specific prompt language.

## Clothing Replacement Prompt Rules

The prompt must include:

"Analyze the reference garment automatically. Extract and match its exact visual attributes, including color, fabric, texture, wash/finish, pattern/logo/text, garment length, fit, silhouette, proportions, structure, drape, stiffness, seams, stitching, buttons, zippers, pockets, collar, cuffs, hem, folds, and material behavior.

Replace only the target garment in the original image with the analyzed reference garment.

Preserve the original person, face, hair, body shape, pose, hands, skin tone, camera angle, composition, lighting direction, shadows, and background.

The replacement must look naturally worn on the body, with accurate garment boundaries, realistic folds, correct shadows, clean edges, and consistent perspective."

## Scene Replacement Rules

When replacing a scene or background:
- preserve the subject and product exactly
- replace only the environment
- match perspective, floor contact, horizon, shadows, and reflection
- keep lighting direction believable
- prevent background objects from crossing the face, hands, logo, or product

If the scene change accidentally alters the product, provide a repair prompt.

## Image Quality Rules

When image quality matters, include:

"Keep the final image clean and realistic, with low noise, no harsh grain, no horizontal banding, no vertical banding, no scanline texture, no compression bands, no dirty blotches, no oversharpened edges, no uneven noise pattern, and no plastic-looking fabric."

## Negative Prompt Defaults

Use or adapt this negative prompt:

"wrong garment color, inaccurate fabric, mismatched texture, wrong wash effect, incorrect fading, wrong garment length, wrong sleeve length, wrong pant length, wrong hem position, wrong fit, wrong silhouette, wrong proportions, too tight, too loose, too cropped, too long, changed shoulder width, changed waist shape, changed hem width, wrong collar size, wrong pocket size, wrong cuff width, wrong button spacing, wrong zipper length, distorted logo, warped text, melted pattern, stretched print, duplicated graphic, blurry seams, fake stitching, plastic fabric, glossy artificial surface, changed face, changed body shape, changed pose, changed hands, changed skin tone, messy garment boundaries, noisy image, harsh grain, horizontal banding, vertical banding, scanline texture, compression bands, dirty blotches, oversharpened edges"

## Prompt QA / Red-Team Check

Before finalizing, check:
- Is the target garment clear?
- Are locked elements clear?
- Does the prompt ask the model to analyze the reference automatically?
- Does it preserve length and fit?
- Does it preserve garment structure?
- Does it preserve color, wash, and fabric texture?
- Does it preserve logos, text, graphics, and patterns?
- Does it prevent face, body, pose, and hand changes?
- Does it control noise, banding, scanlines, grain, and compression artifacts?
- Is the prompt too complex for one generation?
- Is a mask or reference image needed?

If the prompt is weak, rewrite it before answering.

## Multi-Model Prompt Adapter

### NanoBanana-style editor

Use direct edit language:

"Keep [locked elements]. Replace only [target garment] with the garment from the reference image. Automatically analyze and match the reference garment's color, fabric, texture, wash/finish, pattern/logo/text, length, fit, silhouette, structure, seams, stitching, trims, hardware, folds, and material behavior. Preserve natural garment boundaries, shadows, lighting, perspective, and body contact. Do not change [forbidden elements]."

### Image-to-video model

Use motion-safe language:

"Create a short realistic video from the reference image. Preserve the person, product, garment color, fabric, wash, texture, pattern/logo/text, length, fit, silhouette, pose, camera angle, lighting, and composition. Add only subtle camera movement and natural fabric motion. Avoid morphing, warping, flickering, color shift, pattern drift, logo distortion, noise, grain, and banding."

### Text-to-video model

Use full scene language:

"A realistic product video showing [product/person] wearing [garment], automatically matched to the reference garment's color, fabric, texture, wash/finish, pattern/logo/text, length, fit, silhouette, structure, and details. Shot with [camera movement] in [scene] under [lighting]. Clean low-noise image quality, no banding artifacts, no plastic fabric, no distorted graphics."

### Repair prompt

Use targeted correction language:

"Keep everything else unchanged. Correct only [specific failure]. Preserve [locked elements]. Do not alter [forbidden elements]."

## Required Output Format

Return the result in this format:

### 1. Brief
One sentence describing the intended edit.

### 2. Locked Elements
List what must not change.

### 3. Reference Analysis
Summarize the automatically detected garment or video attributes.

### 4. Edit Target
List what should change.

### 5. Main Prompt
Write the full prompt.

### 6. Negative Prompt
Write the negative prompt.

### 7. Model Adapter
Provide NanoBanana-style, image-to-video, or text-to-video version depending on the user's tool.

### 8. Red-Team Check
List likely failure points and how the prompt prevents them.

### 9. Repair Prompts
Provide short targeted repair prompts.

## Common Repair Prompts

### Wrong Garment Color

"Keep everything else unchanged. Correct only the garment color to match the reference garment exactly, including color temperature, saturation, brightness, fading, and uneven dye variation. Preserve the same fabric texture, folds, seams, shadows, wash pattern, print placement, and logo clarity."

### Wrong Wash Or Finish

"Keep the garment shape, fit, color family, and scene unchanged. Correct only the wash or finish to match the reference garment. Preserve fade placement, whiskering, seam fading, distressing level, fabric grain, stitching, and natural material behavior."

### Wrong Length Or Fit

"Keep everything else unchanged. Correct only the garment length and fit to match the reference garment. Match the hem position, sleeve length, pant length, skirt length, silhouette, shoulder width, waist shape, hem width, drape, stiffness, and proportions. Do not change the face, body, pose, background, color, fabric, logo, or pattern."

### Fabric Looks Plastic

"Keep all composition unchanged. Make the fabric look like the reference material, with natural weave, realistic thickness, soft folds, correct drape, believable shadows, and the correct matte or glossy surface. Remove plastic shine and artificial smoothness."

### Logo Or Pattern Distorted

"Keep everything else unchanged. Correct only the printed pattern/logo/text on the garment. Restore the original design with accurate shape, spelling, scale, placement, spacing, orientation, color, and sharp edges. Do not change the clothing color, fabric, fit, lighting, pose, face, body, or background."

### Text Unreadable

"Keep the garment and scene unchanged. Restore the text exactly as [exact text]. Keep the letters sharp, correctly spelled, evenly spaced, and aligned with the original print area. Do not invent new letters or decorative marks."

### Stripes Or Checks Warped

"Keep everything else unchanged. Correct only the stripe/check pattern. Make the lines evenly spaced, continuous across seams, aligned with the garment structure, and naturally following fabric folds without melting or random distortion."

### Scene Changed The Product

"Restore the original person/product exactly. Keep only the new background. Do not change clothing color, fabric texture, fit, logo, pattern, face, body, pose, hands, or camera angle."

### Noise Or Banding

"Keep everything else unchanged. Clean only the image quality. Remove noise, harsh grain, horizontal banding, vertical banding, scanline texture, compression bands, dirty blotches, uneven noise patterns, and oversharpened edges. Preserve garment color, wash effect, fabric texture, pattern, logo, folds, lighting, pose, face, body, and background."
