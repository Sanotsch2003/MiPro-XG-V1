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
        # Add dependencies here
    ],
    description="MiPro Toolkit for assembling and programming.",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    author="Your Name",
    author_email="your.email@example.com",
    url="https://github.com/yourusername/mipro_toolkit",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.6",
)
