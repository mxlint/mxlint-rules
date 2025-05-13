<a id="readme-top"></a>

<!-- PROJECT SHIELDS -->
<span align="center">
  
  [![Contributors][contributors-shield]][contributors-url]
  [![Forks][forks-shield]][forks-url]
  [![Issues][issues-shield]][issues-url]
  [![Unlicense License][license-shield]][license-url]

</span>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/mxlint">
    <img src="https://avatars.githubusercontent.com/u/180859514?s=200&v=4" alt="Logo" width="160">
  </a>

  <h3 align="center">MxLint - Rules</h3>

  <p align="center">
    The repository of rules that come out-of-the-box rules with the MxLint CLI and Mendix Studio Pro extension
    <br />
    <a href="https://mxlint.com/"><strong>MxLint website »</strong></a>
    <br />
    <br />
    <a href="https://mxlint.com/assets/videos/mxlint-extension-2024-09-12-responsive.mp4" target="_blank">View Demo</a>
    &middot;
    <a href="https://github.com/mxlint/mxlint-rules/issues/new" target="_blank">Report an issue</a>
    &middot;
    <a href="https://github.com/mxlint/mxlint-rules/issues/new" target="_blank">Request feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- GETTING STARTED -->
## Getting started
Add new rules to your Mendix project by downloading the applicable `.rego` file and storing it in the project's `.mendix-cache/rules` folder. This folder contains subfolders for each rule category.

Each rule comes with its own `_test` file, which contains test data and one or more test cases.

For more information, see the installation instructions on the [MxLint website](https://mxlint.com/mendix-studio-pro-extension/installation/).


<!-- ROADMAP -->
## Roadmap

- [x] Add README
- [ ] Add changelog
- [ ] Convert all [Mendix Best Practices for Development](https://docs.mendix.com/refguide/dev-best-practices/) to rules


<!-- CONTRIBUTING -->
## Contributing
MxLint and its rules is a fully open source project, driven entirely by the Mendix community! That is why we welcome any and all contributions!

If you want to contribute, this is the way:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

You pull request will be reviewed and, if accepted, merged into the mainline of MxLint.


<!-- LICENSE -->
## License
MxLint&mdash;the CLI tools, the Mendix Studio Pro extension and its rules&mdash;is distributed under the [AGPL license](https://github.com/mxlint/mxlint-rules/blob/main/LICENSE)


<!-- CONTACT -->
## Contact
Xiwen Cheng - [LinkedIn](https://linkedin.com/in/xiwen) - [Email](mailto:x@cinaq.com)

Bart Zantingh - [LinkedIn](https://linkedin.com/in/bartzantingh) - [Email](mailto:bart.zantingh@nl.abnamro.com)

MxLint project home: [https://github.com/mxlint](https://github.com/mxlint)

## Useful links
- [MxLint home](https://mxlint.com/)
- [Open Policy Agent home](https://www.openpolicyagent.org/)
- [Open Policy Agent docs](https://www.openpolicyagent.org/docs/latest/)
- [Rego language reference](https://www.openpolicyagent.org/docs/latest/policy-reference/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/badge/Contributors-3-339933?style=for-the-badge&logo=data:image/svg+xml;base64,PCFET0NUWVBFIHN2ZyBQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj4KDTwhLS0gVXBsb2FkZWQgdG86IFNWRyBSZXBvLCB3d3cuc3ZncmVwby5jb20sIFRyYW5zZm9ybWVkIGJ5OiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4KPHN2ZyB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9IjAgMCAxNiAxNiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiBmaWxsPSJub25lIj4KDTxnIGlkPSJTVkdSZXBvX2JnQ2FycmllciIgc3Ryb2tlLXdpZHRoPSIwIi8+Cg08ZyBpZD0iU1ZHUmVwb190cmFjZXJDYXJyaWVyIiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiLz4KDTxnIGlkPSJTVkdSZXBvX2ljb25DYXJyaWVyIj4gPGcgZmlsbD0iI2ZmZiI+IDxwYXRoIGQ9Ik0zLjQ2MiA3Ljk0MmE1LjYzOCA1LjYzOCAwIDAxMS4yMTYtMi4yOTljLS4xODctLjE0Ny0uOTI4LS43NTUtLjk2My0xLjIzMkMzLjY2MSAzLjYyOSA0LjQwMyAxIDQuNDAzIDFzLTIuMjQgMi44NzYtMi4zOTUgNC4wMzlDMS44ODQgNS45NSAzLjMgNy43NiAzLjQ0OSA3Ljk0NXYtLjAwM2guMDEzem05LjExNC0uMDQ3VjcuOWMwIC4wMDQuMDAzLjAwNy4wMDMuMDEuMjQ4LS4zMTQgMS41My0yIDEuNDEzLTIuODcyQzEzLjgzOCAzLjg3NiAxMS41OTggMSAxMS41OTggMXMuNzQyIDIuNjI5LjY4OCAzLjQxYy0uMDMyLjQ1OC0uNzA3IDEuMDMtLjkzMiAxLjIxYTUuNTcgNS41NyAwIDAxMS4yMjMgMi4yNzV6Ii8+IDxwYXRoIGQ9Ik0xMi41NzYgNy44OTh2LS4wMDZhNS42MTUgNS42MTUgMCAwMC0xLjIyMy0yLjI3NWMtLjg3LS45Ny0yLjA1Ni0xLjU1LTMuMzMzLTEuNTV2My4xMDZoLjAwNGMuMzEzLjAwNC41NjcuMjc0LjU2Ny42MDUgMCAuMDQtLjAwMy4wNzctLjAxLjExNGEuNTgzLjU4MyAwIDAxLS41NTcuNDloLS4wMXYxLjE1M2wtLjAwNiA1LjQ1OGguMTFzMS4yMDUtMS44MzcgMS44NTQtMi4zNjFjLjc2LS42MTUgMi42MDQtMS4zNzcgMi42MDQtMS4zNzd2LTMuMzJsLjAxLS4wMDNjLS4wMDQtLjAwNy0uMDA0LS4wMTctLjAwNy0uMDI0IDAtLjAwMyAwLS4wMDYtLjAwMy0uMDF6Ii8+IDxwYXRoIGQ9Ik04LjAxNCA5LjUzOFY4LjM4NmEuNTguNTggMCAwMS0uNTQ4LS40NDQuNjUuNjUgMCAwMS0uMDIyLS4xNmMwLS4zMzUuMjU3LS42MDUuNTczLS42MDVoLjAwNFY0LjA4Yy0xLjI4NCAwLTIuNDcyLjU4NS0zLjM0MyAxLjU2M2E1LjYxNiA1LjYxNiAwIDAwLTEuMjE2IDIuMjk5aC0uMDF2My4zNjRzMS44NDQuNzYxIDIuNjA0IDEuMzc2Yy42My41MSAxLjg0NyAyLjMxOCAxLjg0NyAyLjMxOGguMTE0di0uMDAzaC0uMDA2bC4wMDMtNS40NTl6Ii8+IDwvZz4gPC9nPgoNPC9zdmc+
[contributors-url]: https://github.com/mxlint/mxlint-rules/graphs/contributors
[forks-shield]: https://img.shields.io/badge/Forks-3-007EC6?style=for-the-badge&logo=git&logoColor=white
[forks-url]: https://github.com/mxlint/mxlint-rules/network
[issues-shield]: https://img.shields.io/badge/Issues-2-DFB317?style=for-the-badge
[issues-url]: https://github.com/mxlint/mxlint-rules/issues
[license-shield]: https://img.shields.io/badge/License-AGPL-663066?style=for-the-badge&logo=gnu
[license-url]: https://github.com/mxlint/mxlint-rules/blob/main/LICENSE
