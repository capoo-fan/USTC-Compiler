好的，这是根据您提供的 PDF 内容转换的 Markdown 代码。

# 实验细节与要求 

## 词法分析器 

现在我们开始编写 Cminusf 的词法解析器。首先,让我们了解一下 Cminusf 的词法规则,随后将介绍实验要求和细节。 

### Cminusf 词法 

Cminusf 是 Cminus 语言的一个子集，该语言的语法在《编译原理与实践》第九章附录中有详细的介绍。  而 Cminusf 在 Cminus 上添加了浮点操作。 

**1. 关键字** 
`else`, `if`, `int`, `float`, `return`, `void`, `while`

**2. 专用符号** 
`+`, `-`, `*`, `/`, `<`, `<=`, `>`, `>=`, `==`, `!=`, `=`, `;`, `,`, `(`, `)`, `[`, `]`, `{`, `}`

**3. 标识符和数值** 
通过下列正则表达式定义：

  * **ID**: `letter (letter | digit)*`
  * **INTEGER**: `digit+` 
  * **FLOAT**: `digit+ . digit+` | `digit* . digit+` 
  * **letter**: `[a-zA-Z]`
  * **digit**: `[0-9]`

**4. 注释**
注释用 `/* ... */` 表示，可以超过一行。注释不能嵌套。 

> 请认真阅读 Cminusf 的词法。其词法特性相比 C 做了大量简化，比如标识符在 C 语言中是合法的，但是在 Cminusf 中是不合法的。 

### 实验内容 

本部分需要各位同学在 `lexical_analyzer.l` 文件中根据 Cminusf 的词法规则完成词法分析器。  在 `lexical_analyzer.l` 文件中，你只需在规则部分补全模式和动作即可，能够输出识别出的 token 的位置 (行号、列号) 和内容 (yytext)。 

例如，对于下面的文本输入： 

```c
int main() {
    return 0;
}
```

识别到的结果应该如下（Token 编号可能因定义顺序而异）： 

| Token   | Token 编号 | Text   | Line, Column(Start, End) |
| :------ | :--------- | :----- | :----------------------- |
| INT     | 282        | `int`    | (1, 1-4)                 |
| ID      | 262        | `main`   | (1, 5-9)                 |
| LPAREN  | 276        | `(`      | (1, 9-10)                |
| RPAREN  | 277        | `)`      | (1, 10-11)               |
| LBRACE  | 281        | `{`      | (1, 12-13)               |
| RETURN  | 284        | `return` | (2, 5-11)                |
| INTEGER | 260        | `0`      | (2, 12-13)               |
| SEMI    | 278        | `;`      | (2, 13-14)               |
| RBRACE  | 279        | `}`      | (3, 1-2)                 |

**请注意以下几点：** 

1.  你需要在 `parser/syntax_analyzer.y` 文件中补全 `token` 的相关内容。 
2.  在补全 `lexical_analyzer.l` 之前，需要先修改 `parser/syntax_analyzer.y` 文件对 token 进行定义。 
3.  Token 编号是程序自动生成的，根据 token 定义顺序不同，输出的 token 号也可能不同，是正常现象。 
4.  对于部分 token（如注释），只需被识别，但不应该被输出到分析结果中，因为这类 token 对程序运行没有作用。 

-----

## 语法分析器 

### Cminusf 语法 

本小节将给出 Cminusf 的语法。我们将 Cminusf 的所有规则分为五类。  起始符号是 `program`。 

1.  **声明 (Declarations)** 
      * `program`, `declaration-list`, `declaration`, `var-declaration`, `fun-declaration`, `local-declarations` 
2.  **语句 (Statements)** 
      * `compound-stmt`, `statement-list`, `expression-stmt`, `iteration-stmt`, `selection-stmt`, `return-stmt` 
3.  **表达式 (Expressions)** 
      * `expression`, `var`, `simple-expression`, `additive-expression`, `term`, `factor`, `call` 
4.  **其他 (Others)** 
      * `params`, `param-list`, `param`, `args`, `arg-list` 

**文法规则：**

1.  `program` → `declaration-list` 
2.  `declaration-list` → `declaration-list declaration` | `declaration` 
3.  `declaration` → `var-declaration` | `fun-declaration` 
4.  `var-declaration` → `type-specifier ID ;` | `type-specifier ID [ INTEGER ] ;` 
5.  `type-specifier` → **int** | **float** | **void** 
6.  `fun-declaration` → `type-specifier ID ( params ) compound-stmt` 
7.  `params` → `param-list` | **void** 
8.  `param-list` → `param-list , param` | `param` 
9.  `param` → `type-specifier ID` | `type-specifier ID [ ]` 
10. `compound-stmt` → `{ local-declarations statement-list }` 
11. `local-declarations` → `local-declarations var-declaration` | `empty` 
12. `statement-list` → `statement-list statement` | `empty` 
13. `statement` → `expression-stmt` | `compound-stmt` | `selection-stmt` | `iteration-stmt` | `return-stmt` 
14. `expression-stmt` → `expression ;` | `;` 
15. `selection-stmt` → **if** `( expression ) statement` | **if** `( expression ) statement` **else** `statement` 
16. `iteration-stmt` → **while** `( expression ) statement` 
17. `return-stmt` → **return** `;` | **return** `expression ;` 
18. `expression` → `var = expression` | `simple-expression` 
19. `var` → `ID` | `ID [ expression ]` 
20. `simple-expression` → `additive-expression relop additive-expression` | `additive-expression` 
21. `relop` → `<=` | `<` | `>` | `>=` | `==` | `!=` 
22. `additive-expression` → `additive-expression addop term` | `term` 
23. `addop` → `+` | `-` 
24. `term` → `term mulop factor` | `factor` 
25. `mulop` → `*` | `/` 
26. `factor` → `( expression )` | `var` | `call` | **INTEGER** | **FLOAT** 
27. `integer` → **INTEGER** 
28. `float` → **FLOATPOINT** 
29. `call` → `ID ( args )` 
30. `args` → `arg-list` | `empty` 
31. `arg-list` → `arg-list , expression` | `expression` 

### 实验内容 

本部分需要同学们完成 `parser/syntax_analyzer.y`。与词法分析器相同，你只需要补全代码中规则部分即可。  如果实现正确，语法分析器可以从 Cminusf 代码分析得到一棵语法树。  例如，对于输入：

```c
int main(void){
    return 0;
}
```

可以得到如下语法树： 

```
program
└─ declaration-list 
   └─ declaration 
      └─ fun-declaration 
         ├─ type-specifier: int 
         ├─ ID: main 
         ├─ params 
         │  └─ void
         └─ compound-stmt 
            ├─ local-declarations: epsilon 
            └─ statement-list 
               └─ statement 
                  └─ return-stmt 
                     ├─ return 
                     └─ expression
                        └─ simple-expression
                           └─ additive-expression 
                              └─ term
                                 └─ factor 
                                    └─ INTEGER: 0 
```

> 这一部分必须严格遵守我们给出的语法，输出必须与标准程序输出完全一致。 

-----

## 实验要求 

### 仓库目录结构 

与本次实验有关的文件如下： 

```
.
├── CMakeLists.txt 
├── eval_lab1.sh 
├── parser
│   ├── CMakeLists.txt 
│   ├── lexical_analyzer.l 
│   └── syntax_analyzer.y 
└── tests
    └── test-parser
        ├── input 
        │   ├── easy
        │   ├── normal 
        │   └── hard 
        ├── output_standard 
        │   ├── easy
        │   ├── normal 
        │   └── hard 
        └── output_student 
            ├── easy
            ├── normal
            └── hard
```

### 编译、运行和评测 

首先将你的实验仓库克隆到本地虚拟机中。 

**编译** 

```bash
# 进入仓库目录
cd <your-repo-name>
# 创建并进入 build 目录
mkdir build && cd build
# 运行 cmake
cmake ..
# 编译
make
```

如果构建成功，你会在 `build/parser` 文件夹下找到 `lexer_parser` 可执行文件。 

**运行** 

```bash
# 用法: ./build/parser/lexer_parser <option> <input_file>

# 词法分析示例
./build/parser/lexer_parser -l tests/testcases/general/1-return.cminus 

# 语法分析示例
./build/parser/lexer_parser -s tests/testcases/general/1-return.cminus 
```

**测试** 
我们提供了 `eval_lab1.sh` 脚本进行快速批量测试。 

  * 该脚本的第一个参数可以是 `easy`, `normal`, `hard`, `testcases/general`。 
  * 有第二个可选参数 `-c`，用于和助教提供的标准参考结果进行比较。 
  * 脚本运行后会将生成结果放在 `tests/test-parser/output_student` 文件夹里。 
  * 助教的参考输出在 `tests/test-parser/output_standard` 中。 

<!-- end list -->

```bash
# 运行 easy 级别的测试
./eval_lab1.sh easy 

# 运行 easy 级别的测试并与标准答案比较
./eval_lab1.sh easy -c
```

**比较与输出示例**
可以使用 `diff` 命令手动比较结果： 

```bash
diff -bB student_output.txt standard_output.txt
```

脚本的失败和成功输出示例：

```
info: analyzing FAIL comment.cminus 
error at line 1 column 4: syntax error 

...

Comparing...
All files are identical. Congratulations! 
```