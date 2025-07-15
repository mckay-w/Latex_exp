# LaTeX 论文模板

一个基于 LaTeX 的模块化论文写作模板，支持多章节独立编译和管理。

## Quick Start

1. 创建新章节
```bash
make new1    # 创建第1章
make new2    # 创建第2章
```

2. 编译章节
```bash
make chap1   # 编译第1章
make chaps   # 编译所有章节
```

3. 编译完整论文
```bash
make         # 编译完整文档
```

4. 清理文件
```bash
make clean   # 清理编译生成的文件
```

## 目录结构

```
.
├── thesis.tex          # 主文档
├── thesis.sty          # 样式文件
├── chapters/           # 章节目录
│   ├── chapter1/      # 第1章
│   │   ├── main.tex   # 章节内容
│   │   └── figures/   # 章节图片
│   └── chapter2/
│       ├── main.tex
│       └── figures/
└── Makefile           # 自动化构建脚本
```

## 特性

- 模块化章节管理
- 独立的图片目录
- Makefile 自动化构建系统

## License
