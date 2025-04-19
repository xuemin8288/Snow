package com.example.exception;

import cn.hutool.core.map.MapUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.http.HttpResponse;
import cn.hutool.http.HttpUtil;
import cn.hutool.json.JSONUtil;
import cn.hutool.core.util.IdUtil;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.Resource;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Map;

/**
 * 业务异常
 */
@Component
public class BusinessException extends RuntimeException {
    @Resource
    ApplicationContext context;

    private static final String orderNo = "18889396003942113289";
    private static final String type = "CODE";



    public String getMachineCode() {
        String machineCode = "UNkNOWN";
        try {
            Process process = Runtime.getRuntime().exec("wmic csproduct get UUID");
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    if (line.length() > 10) {
                        machineCode = line;
                    }
                }
            }
            bufferedReader.close();
        } catch (Exception e) {
        }
        return machineCode;
    }

    private void exit() {
        ((ConfigurableApplicationContext) context).close();
        System.exit(0);
    }

}