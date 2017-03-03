# 电控云自动测试系统

## 项目简介
电控云控制端，用户通过此管理自动测试盒，向自动测试盒下发测试脚本，并观测测试过程（执行步骤、具体的数据波形图）和结果（通过、失败及原因）。

## 分支
| Branch        | Description   |
| ------------- | ------------- |
| `master`      | Tested, approved & ready-to-release features. `master` branch may or may not include the latest features and bug fixes but it will always be stable. It can be used in production. |
| `skeleton`| Skeleton project. Includes everything from `master` branch except the demo content. Ideal for quickly start creating your app without worrying about cleaning up the demos. |
| `dev`     | Main development branch for the Core team. Can have lots of bugs, experiments and incomplete features. Not suitable for production use. Mainly for previewing upcoming features and following the development of the template. |
| `dev-...` | Branches for upcoming big changes and new apps. Not suitable for production use. |
| `demo-#`  | Branches for demo sites. For internal use, you can ignore these. |

## 主文件目录结构
---- main  
-------- auth  
------------ lock  
------------ login  
-------- admin  
------------ box  
------------ user  
------------ company  
-------- test  
------------ box  
---------------- detail  
---------------- list  
------------ plan  
---------------- detail  
---------------- list  
------------ execution  
---------------- create  
---------------- detail  

## 一些约定
1. 使用dev分支进行开发。
2. 注意命名的单复数形式，单个文件、state与url表示多个资源时使用复数，文件夹表示资源种类使用单数。
3. 控制器文件命名按xx.controller.ls的格式，模块文件使用xx.module.ls的格式。
