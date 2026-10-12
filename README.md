# 跨软件最小闭环

> 目标：围绕“收集客户资料、形成知识库、拆分任务、跟踪交付、录制教程、发布开源成果”，搭建一条可运行、可追溯、边界清晰的最小闭环。
> 场景：远岑咖啡客户需求跟踪（虚构资料）。

## 1. 一句话架构

```text
飞书多维表格
  → 导出客户资料 CSV
  → 本地 build-loop.ps1 转换
  → Markdown 知识卡片 + 任务台账
  → 交付清单与验收证据
  → Typora 预览教程
  → ffmpeg 生成教程视频
  → Git diff/敏感信息检查
  → GitHub 公开仓库
```

## 2. 工具边界与输入输出

| 工具/载体 | 负责什么 | 输入 | 输出 | 权限边界 |
| --- | --- | --- | --- | --- |
| [飞书客户跟踪 Base](https://uiw4jqvloec.feishu.cn/base/NsJkbn9OTau8EJscDQaclBYIn8E?table=tbliJWznaXpJs0x2&view=vewj28KDug) | 收集客户资料、更新状态、跟踪截止日期 | 客户需求、负责人、附件 | 筛选后的 CSV/表格记录 | 仅业务成员可编辑；不放密码、身份证和支付信息 |
| `data/customer_intake.csv` | 脱敏后的交换文件 | 飞书导出记录 | 本地可重复处理的结构化输入 | 只保留虚构或脱敏字段 |
| `scripts/build-loop.ps1` | 规则化转换 | CSV | 知识卡片、任务台账、运行日志 | 本地运行；不调用外部 API |
| `knowledge/` | 形成可检索知识库 | 客户背景、约束、验收标准 | Markdown 知识卡片 | 可公开内容；禁止写入客户隐私 |
| `tasks/` 与 `delivery/` | 拆分任务、跟踪交付 | 知识卡片和方案 | 任务台账、交付清单 | 由项目成员维护；状态变更留痕 |
| Typora | 阅读、编辑和预览教程 | Markdown | 可读教程文档 | 本地编辑，不负责发布权限 |
| ffmpeg + Windows 中文 TTS | 录制/生成教程演示 | 教程脚本、章节文字 | MP4 教程视频 | 本地生成，不自动上传 |
| GitHub | 发布开源成果 | 已脱敏 Git 仓库 | 公开仓库和版本历史 | 只推送脱敏资料；不上传令牌或真实客户数据 |

评分关注的是这些输入输出和边界是否闭合，而不是工具数量。

## 3. 实际产物

- [脱敏客户资料输入](data/customer_intake.csv)
- [知识库卡片](knowledge/客户需求知识卡片.md)
- [任务台账](tasks/task_ledger.csv)
- [交付清单](delivery/交付清单.md)
- [教程脚本](tutorial/教程脚本.md)
- [验收证据](evidence/验收证据.md)
- [开源发布说明](开源发布说明.md)
- [教程视频](tutorial/cross-software-minimal-loop-tutorial.mp4)

## 4. 运行闭环

在本目录执行：

```powershell
Set-Location .\scripts
pwsh -NoProfile -File .\build-loop.ps1
```

脚本会读取 `data/customer_intake.csv`，生成或更新：

- `knowledge/客户需求知识卡片-自动生成.md`
- `tasks/task_ledger.csv`
- `evidence/build-run.txt`

## 5. 验收方法

1. 在飞书 Base 中确认输入记录只包含虚构或已脱敏字段。
2. 导出 CSV 后运行转换脚本，检查知识卡片和任务台账行数与输入一致。
3. 在 Typora 中打开教程脚本，确认链接、表格、代码块和视频路径有效。
4. 播放教程视频，确认内容覆盖收集、沉淀、拆分、交付、验收和发布六步。
5. 执行 `git diff --check`、敏感信息扫描和文件清单复核。
6. 访问公开 GitHub 仓库，用一个无本地文件的临时目录克隆，重新运行脚本。

## 6. 证据索引

- 数据转换运行证据：`evidence/build-run.txt`
- 跨软件接口与权限说明：本文件第 2 节
- 功能验收结果：[验收证据](evidence/验收证据.md)
- 发布结果：[开源发布说明](开源发布说明.md)

## 7. 公开仓库

[GitHub：cyGao8399/cross-software-minimal-loop](https://github.com/cyGao8399/cross-software-minimal-loop)
