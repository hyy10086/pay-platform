<%--
Created by IntelliJ IDEA.
User: zjt
Date: 2016/10/6
Time: 15:21
To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
pageContext.setAttribute("baseURL", pageContext.getServletContext().getContextPath());
%>

<#-- 宏定义,freemarker与mybatis,jsp都采用类似于el表达式的操作,因此需要进行转义 -->
<#macro mapperEl value>${r"#{"}${value}}</#macro>                                       <#-- #{value}-->
<#macro mapperLike value>${r"CONCAT('%','${"}${value}${r"}','%')"}</#macro>             <#-- CONCAT('%','${value}','%' ) -->
<#macro jspEl value>${r"${"}${value}}</#macro>

<div class="modal-header">
    <button type="button" class="bootbox-close-button close" data-dismiss="modal" aria-hidden="true">x</button>
    <h4 class="modal-title">编辑${moduleName}</h4>
</div>

<div class="modal-body">
    <div class="bootbox-body">

    <form id="edit${classPrefix}Form" action="<@jspEl "baseURL" />${requestUrl}/update${classPrefix}" class="form-horizontal" method="post">

        <input type="hidden" name="<@jspEl "_csrf.parameterName" />" value="<@jspEl "_csrf.token" />"/>
        <input type="hidden" id="editId" name="id"/>

    <#list columnList as column>
        <#if column._isEdit>

        <#-- 普通文本 -->
            <#if column.formType == "text" >
                <div class="form-group">
                    <label class="col-md-3 col-sm-3 control-label">${column.remarks}：</label>
                    <div class="col-md-8 col-sm-8">
                        <input id="edit${column.fieldName?cap_first}" name="${column.fieldName}"  <#if column._isRequired >check-type="required"</#if>
                             type="text" class="form-control" maxlength="${column.size}" placeholder="请输入${column.remarks}"/>
                    </div>
                </div>
            <#-- 日期类型 -->
            <#elseif column.formType == "datetime" >
                <div class="form-group">
                    <label class="col-md-3 col-sm-3 control-label">${column.remarks}：</label>
                    <div class="col-md-8 col-sm-8">
                        <div class='input-group date' id="edit${column.fieldName?cap_first}Div">
                            <input type='text' id="edit${column.fieldName?cap_first}" name="${column.fieldName}" <#if column._isRequired >check-type="required"</#if>
                                 class="form-control" data-date-format="YYYY-MM-DD HH:mm" placeholder="请输入${column.remarks}"/>
                                    <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-calendar"></span>
                                    </span>
                        </div>
                    </div>
                </div>
            <#-- 下拉框 -->
            <#elseif column.formType == "select" >
                <div class="form-group">
                    <label class="col-md-3 col-sm-3 control-label">${column.remarks}：</label>
                    <div class="col-md-8 col-sm-8">
                        <select id="edit${column.fieldName?cap_first}" name="${column.fieldName}" class="form-control"></select>
                    </div>
                </div>
            <#-- 单选按钮/复选框 -->
            <#elseif column.formType == "radio" || column.formType == "checkbox" >
                <div class="form-group">
                    <label class="col-md-3 col-sm-3 control-label">${column.remarks}：</label>
                    <div class="col-md-8 col-sm-8" id="edit${column.fieldName?cap_first}" name="${column.fieldName}">
                    </div>
                </div>
            <#-- 富文本 -->
            <#elseif column.formType == "richText" >
                <div class="form-group">
                    <label class="col-md-3 col-sm-3 control-label">${column.remarks}：</label>
                    <div class="col-md-8 col-sm-8">
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-md-12 col-sm-12">
                <%-- <script id="edit${column.fieldName?cap_first}" type="text/plain" style="width:auto;height:500px;"></script> --%>
                        <textarea id="editReal${column.fieldName?cap_first}" name="${column.fieldName}" style="display:none;"></textarea>
                    </div>
                </div>
            <#--单图片 -->
            <#elseif column.formType == "singleImage" >
                <div class="form-group">
                    <label class="col-md-3 col-sm-3 control-label">${column.remarks}：</label>
                    <div class="col-md-8 col-sm-8">
                        <div class="kv-avatar">
                            <!-- 上传文件表单组件 -->
                            <input id="file${column.fieldName?cap_first}" type="file" class="file-loading"/>
                        </div>
                    </div>
                    <!-- 隐藏域,保存上传文件的路径  -->
                    <input id="edit${column.fieldName?cap_first}" name="${column.fieldName}" type="hidden" />
                </div>
            <#-- 多图片上传 -->
            <#elseif column.formType == "multiImage" >
                <div class="form-group">
                    <label class="col-md-3 col-sm-3 control-label">${column.remarks}：</label>
                    <div class="col-md-9 col-sm-9">
                        <!-- 上传文件表单组件 -->
                        <input id="multiFile${column.fieldName?cap_first}" multiple type="file" class="file-loading"/>
                    </div>
                    <!-- 隐藏域,保存上传文件的路径  -->
                    <input id="edit${column.fieldName?cap_first}" name="${column.fieldName}" type="hidden"/>
                </div>
            </#if>

        </#if>
    </#list>

    </form>

</div>
</div>

<div class="modal-footer operation-button">
        <button data-bb-handler="success" type="button" class="btn btn-success">保存</button>
        <button data-bb-handler="cancel" type="button" class="btn btn-danger">取消</button>
</div>

<#if containRichTextField>
<script type="text/javascript" charset="utf-8" src="<@jspEl "baseURL" />/resources/plugins/ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="<@jspEl "baseURL" />/resources/plugins/ueditor/ueditor.all.js"> </script>
<!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
<script type="text/javascript" charset="utf-8" src="<@jspEl "baseURL" />/resources/plugins/ueditor/lang/zh-cn/zh-cn.js"></script>
</#if>
<script type="text/javascript">

    $(function () {

        $('#edit${classPrefix}Form').validation();            //表单验证初始化

    });

</script>