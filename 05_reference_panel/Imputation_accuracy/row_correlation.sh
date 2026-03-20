#!/bin/bash

# 检查参数数量
if [ $# -ne 3 ]; then
    echo "用法: $0 <文件1> <文件2> <输出文件>"
    echo "示例: $0 data1.txt data2.txt r_squared_results.txt"
    exit 1
fi

# 分配参数变量
FILE1="$1"
FILE2="$2"
OUTPUT="$3"

# 检查输入文件是否存在
if [ ! -f "$FILE1" ]; then
    echo "错误: 文件 $FILE1 不存在!"
    exit 1
fi

if [ ! -f "$FILE2" ]; then
    echo "错误: 文件 $FILE2 不存在!"
    exit 1
fi

# 使用paste命令合并两个文件的对应行，然后通过R处理每行
paste "$FILE1" "$FILE2" | R --slave --vanilla -e '
    # 读取标准输入
    con <- file("stdin", "r")
    
    # 打开输出文件
    out_con <- file("'$OUTPUT'", "w")
    
    # 写入结果表头
    cat("行号\tR方值\t有效数据点数量\n", file = out_con)
    
    line_num <- 1
    while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
        # 跳过空行
        if (nchar(trimws(line)) == 0) {
            cat(sprintf("%d\tNO_data\t0\n", line_num), file = out_con)
            line_num <- line_num + 1
            next
        }
        
        # 分割数据：前半部分来自文件1，后半部分来自文件2
        parts <- strsplit(line, "\t")[[1]]
        mid <- length(parts) / 2
        
        # 提取两个文件的行数据，允许NA值
        row1 <- as.numeric(parts[1:mid])
        row2 <- as.numeric(parts[(mid+1):length(parts)])
        
        # 检查数据长度是否匹配
        if (length(row1) != length(row2)) {
            cat(sprintf("%d\tbadData\t0\n", line_num), file = out_con)
            line_num <- line_num + 1
            next
        }
        
        # 移除包含NA的位置
        valid_indices <- !is.na(row1) & !is.na(row2)
        valid_count <- sum(valid_indices)
       
        # 至少需要3个有效数据点才能计算有意义的R方
        if (valid_count < 3) {
            cat(sprintf("%d\tNOT_enough_data\t%d\n", line_num, valid_count), file = out_con)
            line_num <- line_num + 1
            next
        }
     
        # 使用有效数据计算相关性
        x <- row1[valid_indices]
        y <- row2[valid_indices]

        # 检查x是否无变异（所有值均为0）
        if (all(x == 0) || sd(x) == 0) {
            cat(sprintf("%d\tNO_true_variant\t%d\n", line_num, valid_count), file = out_con)
            line_num <- line_num + 1
            next
        }
            
        model <- lm(x ~ y)
        r_squared <- summary(model)$r.squared
        
        # 写入结果
        cat(sprintf("%d\t%.6f\t%d\n", line_num, r_squared, valid_count), file = out_con)
        
        # 每1000行显示进度
        if (line_num %% 1000 == 0) {
#           cat(sprintf("已处理 %d 行...\n", line_num))
        }
        
        line_num <- line_num + 1
    }
    
    # 关闭连接
    close(con)
    close(out_con)
    cat(sprintf("处理完成，共 %d 行。结果已保存到 %s\n", line_num - 1, "'"$OUTPUT"'"))
'

# 检查执行状态
if [ $? -eq 0 ]; then
    echo "操作成功完成"
else
    echo "处理过程中出现错误"
    exit 1
fi

