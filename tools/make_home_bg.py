from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter, ImageChops


OUT = Path(__file__).resolve().parents[1] / "src" / "main" / "webapp" / "assets" / "images" / "home-hero-bg.png"
OUT.parent.mkdir(parents=True, exist_ok=True)

W, H = 1920, 1080
img = Image.new("RGB", (W, H), "#0b1020")
px = img.load()

top_left = (10, 16, 34)
bottom_right = (19, 56, 68)
for y in range(H):
    for x in range(W):
        t = (x / (W - 1) * 0.58) + (y / (H - 1) * 0.42)
        r = int(top_left[0] * (1 - t) + bottom_right[0] * t)
        g = int(top_left[1] * (1 - t) + bottom_right[1] * t)
        b = int(top_left[2] * (1 - t) + bottom_right[2] * t)
        px[x, y] = (r, g, b)

overlay = Image.new("RGBA", (W, H), (0, 0, 0, 0))
d = ImageDraw.Draw(overlay)

def glass_box(x1, y1, x2, y2, fill, outline, radius=36):
    d.rounded_rectangle((x1, y1, x2, y2), radius=radius, fill=fill, outline=outline, width=3)

def soft_glow(cx, cy, rw, rh, color, opacity=140):
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ld = ImageDraw.Draw(layer)
    ld.ellipse((cx-rw, cy-rh, cx+rw, cy+rh), fill=(*color, opacity))
    return layer.filter(ImageFilter.GaussianBlur(45))

# architectural panes on the right side
for x in [1180, 1370, 1560]:
    d.rounded_rectangle((x, 120, x + 180, 820), radius=40, fill=(255, 255, 255, 22), outline=(255, 255, 255, 28), width=2)
    for yy in range(170, 780, 140):
        d.line((x + 20, yy, x + 160, yy), fill=(255, 255, 255, 24), width=2)

for x in [1080, 1260, 1440, 1620]:
    d.line((x, 110, x, 860), fill=(255, 255, 255, 12), width=2)
for y in [140, 260, 390, 520, 650, 780]:
    d.line((1050, y, 1840, y), fill=(255, 255, 255, 12), width=2)

# subtle illuminated counter strip
counter = Image.new("RGBA", (W, H), (0, 0, 0, 0))
cd = ImageDraw.Draw(counter)
cd.rounded_rectangle((1060, 820, 1820, 910), radius=38, fill=(255, 180, 92, 118), outline=(255, 220, 160, 120), width=3)
cd.rounded_rectangle((1090, 838, 1790, 892), radius=26, fill=(255, 255, 255, 18), outline=(255, 255, 255, 24), width=2)
counter = counter.filter(ImageFilter.GaussianBlur(8))
overlay = Image.alpha_composite(overlay, counter)

# left-side open space with a few frosted panes
glass = Image.new("RGBA", (W, H), (0, 0, 0, 0))
gd = ImageDraw.Draw(glass)
gd.rounded_rectangle((120, 160, 980, 860), radius=70, fill=(255, 255, 255, 14), outline=(255, 255, 255, 18), width=2)
for y in [260, 390, 520, 650, 780]:
    gd.line((180, y, 920, y), fill=(255, 255, 255, 14), width=2)
for x in [250, 410, 570, 730, 890]:
    gd.line((x, 220, x, 820), fill=(255, 255, 255, 12), width=2)
glass = glass.filter(ImageFilter.GaussianBlur(2))
overlay = Image.alpha_composite(overlay, glass)

# stylized food tray and plate on the lower left
tray = Image.new("RGBA", (W, H), (0, 0, 0, 0))
td = ImageDraw.Draw(tray)
td.rounded_rectangle((210, 650, 900, 870), radius=42, fill=(26, 30, 46, 210), outline=(255, 255, 255, 34), width=3)
td.rounded_rectangle((245, 685, 865, 835), radius=34, fill=(44, 52, 74, 220), outline=(255, 255, 255, 28), width=2)
td.ellipse((330, 700, 660, 860), fill=(246, 242, 228, 230), outline=(255, 255, 255, 35), width=4)
td.ellipse((390, 760, 600, 830), fill=(194, 116, 66, 228))
td.ellipse((445, 730, 565, 800), fill=(82, 144, 96, 220))
td.rounded_rectangle((700, 730, 825, 810), radius=22, fill=(233, 190, 112, 220))
td.rounded_rectangle((740, 700, 790, 760), radius=12, fill=(242, 242, 242, 220))
td.line((725, 690, 735, 835), fill=(255, 255, 255, 80), width=3)
td.line((780, 690, 790, 835), fill=(255, 255, 255, 80), width=3)
tray = tray.filter(ImageFilter.GaussianBlur(1))
overlay = Image.alpha_composite(overlay, tray)

# warm ceiling lights as wide reflections, not blobs
lights = Image.new("RGBA", (W, H), (0, 0, 0, 0))
ld = ImageDraw.Draw(lights)
for x, y, w, h in [(1280, 190, 190, 28), (1510, 210, 160, 24), (1680, 240, 120, 22)]:
    ld.rounded_rectangle((x, y, x + w, y + h), radius=10, fill=(255, 198, 120, 180))
lights = lights.filter(ImageFilter.GaussianBlur(20))
overlay = Image.alpha_composite(overlay, lights)

# subtle diagonal accent strokes
strokes = Image.new("RGBA", (W, H), (0, 0, 0, 0))
sd = ImageDraw.Draw(strokes)
sd.line((980, 140, 1780, 110), fill=(120, 220, 215, 90), width=5)
sd.line((1020, 940, 1840, 840), fill=(255, 210, 120, 80), width=4)
strokes = strokes.filter(ImageFilter.GaussianBlur(0.5))
overlay = Image.alpha_composite(overlay, strokes)

# vignette
vig = Image.new("L", (W, H), 0)
vd = ImageDraw.Draw(vig)
vd.rectangle((0, 0, W, H), fill=255)
vig = ImageChops.invert(vig)
vig = vig.filter(ImageFilter.GaussianBlur(180))
vig_rgb = Image.new("RGBA", (W, H), (0, 0, 0, 0))
vig_rgb.putalpha(vig.point(lambda p: int(p * 0.7)))
overlay = Image.alpha_composite(overlay, vig_rgb)

final = Image.alpha_composite(img.convert("RGBA"), overlay)
final.save(OUT)
print(OUT)
