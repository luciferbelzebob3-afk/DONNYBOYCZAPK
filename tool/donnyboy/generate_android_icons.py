"""Prepare Android launcher densities from the approved DonnyBoy artwork.

Run from the repository root with Python and Pillow installed.
"""
from pathlib import Path

from PIL import Image

SOURCE = Path('assets/img/donnyboy_icon.png')
RES = Path('android/app/src/main/res')
DENSITIES = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}


def render(artwork, size, extent):
    icon = Image.new('RGBA', (size, size))
    artwork = artwork.copy()
    artwork.thumbnail((extent, extent), Image.Resampling.LANCZOS)
    icon.alpha_composite(artwork, ((size - artwork.width) // 2,
                                 (size - artwork.height) // 2))
    return icon


def main():
    source = Image.open(SOURCE).convert('RGBA')
    # Ignore nearly invisible export pixels when measuring the character.
    bounds = source.getchannel('A').point(lambda alpha: 255 if alpha > 16 else 0).getbbox()
    if bounds is None:
        raise ValueError('The icon source is empty')
    artwork = source.crop(bounds)
    for density, scale in DENSITIES.items():
        folder = RES / f'mipmap-{density}'
        folder.mkdir(parents=True, exist_ok=True)
        # Keep the complete character within the adaptive icon safe circle.
        render(artwork, round(108 * scale), round(52 * scale)).save(
            folder / 'ic_launcher_foreground.png', optimize=True)
        legacy = render(artwork, round(48 * scale), round(38 * scale))
        for name in ('ic_launcher.png', 'ic_launcher_round.png'):
            legacy.save(folder / name, optimize=True)


if __name__ == '__main__':
    main()
