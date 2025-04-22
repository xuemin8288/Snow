package com.example.entity;

public class TypeAddMap {
    private int typekey;
    private String address;
    private int value;

    // 无参构造函数
    public TypeAddMap() {
    }

    // 有参构造函数
    public TypeAddMap(int typekey, String address, int value) {
        this.typekey = typekey;
        this.address = address;
        this.value = value;
    }

    // Getters and Setters
    public int getTypekey() {
        return typekey;
    }

    public void setTypekey(int typekey) {
        this.typekey = typekey;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }
}