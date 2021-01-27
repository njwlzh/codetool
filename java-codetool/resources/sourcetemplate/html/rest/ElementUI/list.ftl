<template>
    <div class="pageContainer flex flex-v">
        <div class="crumbs">
            <el-breadcrumb separator="/">
                <el-breadcrumb-item> <i class="el-icon-menu"></i> ${caption!}管理 </el-breadcrumb-item>
            </el-breadcrumb>
        </div>

        <page-table
            ref="table"
            :loading="loading"
            class="merchant-table flex-1 shadowbox"
            :tableData="tableData"
            :columnsTotal.sync="columnsTotal"
            :pageOptions="pageOptions"
            :options="options"
            @current-change="currentChange"
            @size-change="sizeChange"
        >
            <page-filter ref="filter" :buttonList="buttonList" :showAdvanced="false">
            	<#if columns??>
					<#list columns as col>
					<#if col.length lte 100>
					<#if col.propertyType?index_of('Date')!=-1>
					<el-date-picker v-model="searchForm.${col.propertyName}" type="date" value-format="yyyy-MM-dd" placeholder="${col.caption!}"></el-date-picker>
					<#else>
					<v-input label="${col.caption!}" v-model="searchForm.${col.propertyName}" :width="formWidth" inline-block formItem />
					</#if>
					</#if>
					</#list>
				</#if>
            </page-filter>
            <template slot="fun" slot-scope="scope">
                <el-button size="small" @click="handleCreate(scope.row)">编辑</el-button>
                <el-button type="danger" @click="handleDelete(scope.row)" plain size="small">删除</el-button>
            </template>
            <template slot="status" slot-scope="scope">
                <p v-if="scope.row.state == 1">在用</p>
                <p v-if="scope.row.state == 3">停用</p>
            </template>
        </page-table>
        <page-dialog :title="diaTitle" :visible.sync="dialogVisible" @submit="handleSubmit" width="45%" append-to-body>
            <ele-form ref="eleForm" :rules="formRules" v-model="formProps" :formData="formData">
            </ele-form>
        </page-dialog>
    </div>
</template>

<script>
import table from '@/mixins/table';
import pageFilter from '@/components/lib/data/page-filter';
import eleForm from '@/components/layout/ele-form';
export default {
    name: '${entityName}Management',
    mixins: [table],
    components: {
        pageFilter,
        eleForm,
        'page-dialog': () => import(/* webpackChunkName: "async-components" */ '@/components/lib/data/page-dialog')
    },
    data() {
        return {
            labelWidth: 100,
            formWidth: 170,
            searchForm: {
            },
            statusOptions: [
                {
                    key: 3,
                    value: '停用'
                },
                {
                    key: 1,
                    value: '在用'
                }
            ],
            buttonList: [
                {
                    text: '查询',
                    click: () => {
                        this.query();
                    }
                },
                {
                    text: '添加${caption!}',
                    click: () => {
                        this.handleCreate();
                    }
                }
            ],
            options: {
                showSet: false,
                showIndex: true,
                canCheck: false
            },
            columnsTotal: [
            	<#list columns as col>
		        {display: true, "prop": "${col.propertyName!}","label":"${col.caption!}", "width":"${(col.length<60)?string(60,(col.length)?c)}px"},
		        </#list>
            ],
            diaTitle: '新增',
            dialogVisible: false,
            formProps: {},
            initProps: {},
            formRules: {
            	<#list columns as col>
            	${col.propertyName}:[
            		required:${(col.nullable)?string('false','true')},
            		message: '请输入${col.caption!}',
                    trigger: 'blur'
            	],
            	</#list>
            }
        };
    },
    computed: {
        formData() {
            return {
            	<#list columns as col>
            	${col.propertyName}:{
            		type: 'input',
            		label: '${col.caption!}',
                    width: '100%'
            	},
            	</#list>
            };
        }
    },
    mounted() {
        try {
            this.loading = true;
            // this.setTableData();
            let p1 = this.getTableData();
            Promise.all([p1]).then(([p1]) => {
                p1 && (this.tableData = [...p1]);
                this.loading = false;
            });
        } catch (error) {
            console.log(error);
        }
    },
    methods: {
        // 删除
        handleDelete(row) {
            this.$confirm('是否确认删除此${caption!}?', '提示', {
                confirmButtonText: '确认',
                cancelButtonText: '取消'
            })
                .then(() => {
                    let params = {
                        id: row.id,
                        state: 3
                    };
                    this.$http.deleteData(`/${moduleName}/${entityName}/ajax/updateState`, params, {}).then((res) => {
                        if (res.result == 0) {
                            this.$success('删除成功!');
                            this.query();
                        }
                    });
                })
                .catch(() => {});
        },
        // 添加、编辑${caption!}
        async handleCreate(row) {
            if (!row) {
                // 新增主菜单
                this.diaTitle = '新增${caption!}';
                this.formProps = Object.assign({}, this.initProps, {
                    accStatus: 1,
                    status: 1
                });
                this.id = '';
                this.dialogVisible = true;
                this.$nextTick(() => {
                    this.$refs.eleForm.clearValidate();
                    this.$refs.eleForm.doRender(this.formData);
                });
            } else {
                this.diaTitle = '编辑${caption!}';
                this.id = row.id;
                let result = await this.get${entityCamelName}(row.id);
                this.$loading().close();
                if (!result) {
                    this.$error('请求异常，请稍后重试');
                    return;
                }
                let { <#list columns as col>${col.propertyName}<#if col_index<columns?size>,</#if></#list>} = result.data;
                this.formProps = Object.assign({}, this.initProps, {
                    <#list columns as col>${col.propertyName}<#if col_index<columns?size>,</#if></#list>
                });
                this.dialogVisible = true;
                this.$nextTick(() => {
                    this.$refs.eleForm.clearValidate();
                    this.$refs.eleForm.doRender(this.formData);
                });
            }
        },
        // 获取${caption!}详情
        async get${entityCamelName}(id) {
            this.$loading();
            let obj = {
                id: id
            };
            let res = await this.$http.getData('/${moduleName}/${entityName}/ajax/load${entityCamelName}', obj, {
                auth: { debounce: 1 }
            });
            if (res.result == 0) {
                return res.data;
            } else {
                return false;
            }
        },
        handleSubmit() {
            this.$refs.eleForm.validate((valid) => {
                if (valid) {
                    let url = '';
                    let type = '';
                    let params = Object.assign({}, this.formProps, {});
                    if (!this.id) {
                        // 新增
                    } else {
                        // 编辑
                        params = Object.assign({}, params, { id: this.id });
                    }
                    type = 'postJSONData';
                    url = `/${moduleName}/${entityName}/ajax/save${entityCamelName}`;
                    // return;
                    this.$http[type](url, params, {}).then((res) => {
                        if (res.result == 0) {
                            this.$success(this.id ? '编辑成功' : '新增成功');
                            this.setTableData();
                            this.dialogVisible = false;
                        }
                    });
                }
            });
        },
        // 获取表格数据
        async getTableData() {
            let obj = {
                pageNo: this.pageOptions.current,
                pageSize: this.pageOptions.pageSize
            };
            obj = Object.assign({}, obj, this.searchForm);
            let res = await this.$http.getData('/${moduleName}/${entityName}/ajax/load${entityCamelName}List', obj, {
                auth: { debounce: 3 }
            });
            this.tableData = res.data;
            this.pageOptions.total = res.recordsTotal;
            return res.data;
        }
    }
};
</script>

<style lang="scss">

</style>
