from setuptools import setup, find_packages

setup(
    name="mipro_toolkit",
    version="0.1.0",
    packages=find_packages(),
    entry_points={
        "console_scripts": [
            "mipro=mipro_toolkit:main",  # The `mipro` command maps to `main()` in `__init__.py`
        ],
    },
    install_requires=[
        "pyserial>=3.5,<4.0",
        "matplotlib==3.10.0",
        "PyQt5==5.15.11"
    ],
    description="MiPro-XG Toolkit for assembling and programming.",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    author="Jonas Mueller",
    author_email="jonas.mueller.wpk@gmail.com",
    url="https://github.com/Sanotsch2003/MiPro-XG-V1.git",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.6",
)
