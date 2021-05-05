<!DOCTYPE html>
<html>
<head>
    <title>Meeting会议管理系统</title>
    <link rel="stylesheet" href="/styles/common.css"/>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.js"></script>

    <script src="/My97DatePicker/WdatePicker.js"></script>

    <style type="text/css">
        #divfrom {
            float: left;
            width: 150px;
        }

        #divto {
            float: left;
            width: 150px;
        }

        #divoperator {
            float: left;
            width: 50px;
            padding: 60px 5px;
        }

        #divoperator input[type="button"] {
            margin: 10px 0;
        }

        #selDepartments {
            display: block;
            width: 100%;
        }

        #selEmployees {
            display: block;
            width: 100%;
            height: 200px;
        }

        #selSelectedEmployees {
            display: block;
            width: 100%;
            height: 225px;
        }
    </style>
    <script type="application/javascript">
        function employee(employeeid, employeename) {
            this.employeeid = employeeid;
            this.employeename = employeename;
        }

        function department(departmentid, departmentname, employees) {
            this.departmentid = departmentid;
            this.departmentname = departmentname;
            this.employees = employees;
        }

        var data = new Array(
            new department(1, "技术部", new Array(
                new employee(1001, "a00"), new employee(1002, "a01"), new employee(1003, "a02"), new employee(1004, "a03"))),
            new department(2, "销售部", new Array(
                new employee(2001, "b00"), new employee(2002, "b01"), new employee(2003, "b02"), new employee(2004, "b03"))),
            new department(3, "市场部", new Array(
                new employee(3001, "c00"), new employee(3002, "c01"), new employee(3003, "c02"), new employee(3004, "c03"))),
            new department(4, "行政部", new Array(
                new employee(4001, "d00"), new employee(4002, "d01"), new employee(4003, "d02"), new employee(4004, "d03"))));

        var selDepartments;
        var selEmployees;
        var selSelectedEmployees;

        function body_load() {
            selDepartments = document.getElementById("selDepartments");
            selEmployees = document.getElementById("selEmployees");
            selSelectedEmployees = document.getElementById("selSelectedEmployees");

            $.get("/alldeps", function (data) {
                for (let i = 0; i < data.length; i++) {
                    var item = data[i];
                    var dep = document.createElement("option");
                    dep.value = item.departmentId;
                    dep.text = item.departmentName;
                    selDepartments.appendChild(dep);
                }
                fillEmployees();
            })
        }

        function fillEmployees() {
            clearList(selEmployees);
            var departmentid = selDepartments.options[selDepartments.selectedIndex].value;

            $.get("/getempbydepid?depId=" + departmentid, function (data) {
                for (i = 0; i < data.length; i++) {
                    var emp = document.createElement("option");
                    emp.value = data[i].employeeId;
                    emp.text = data[i].employeeName;
                    selEmployees.appendChild(emp);
                }
            })
        }

        function clearList(list) {
            while (list.childElementCount > 0) {
                list.removeChild(list.lastChild);
            }
        }

        function selectEmployees() {
            for (var i = 0; i < selEmployees.options.length; i++) {
                if (selEmployees.options[i].selected) {
                    addEmployee(selEmployees.options[i]);
                    selEmployees.options[i].selected = false;
                }
            }
        }

        function deSelectEmployees() {
            var elementsToRemoved = new Array();
            var options = selSelectedEmployees.options;
            for (var i = 0; i < options.length; i++) {
                if (options[i].selected) {
                    elementsToRemoved.push(options[i]);
                }
            }
            for (i = 0; i < elementsToRemoved.length; i++) {
                selSelectedEmployees.removeChild(elementsToRemoved[i]);
            }
        }

        function addEmployee(optEmployee) {
            var options = selSelectedEmployees.options;
            var i = 0;
            var insertIndex = -1;
            while (i < options.length) {
                if (optEmployee.value == options[i].value) {
                    return;
                } else if (optEmployee.value < options[i].value) {
                    insertIndex = i;
                    break;
                }
                i++;
            }
            var opt = document.createElement("option");
            opt.value = optEmployee.value;
            opt.text = optEmployee.text;
            opt.selected = true;

            if (insertIndex == -1) {
                selSelectedEmployees.appendChild(opt);
            } else {
                selSelectedEmployees.insertBefore(opt, options[insertIndex]);
            }
        }
    </script>
</head>
<body onload="body_load()">
<div class="container">
    <#include 'top.ftl'>
    <div class="page-body">
        <#include 'leftMenu.ftl'>
        <div class="page-content">
            <div class="content-nav">
                会议预定 > 预定会议
            </div>
            <form action="/doAddMeeting" method="post" class="form-horizontal">
                <fieldset>
                    <legend>会议信息</legend>
                    <table class="formtable">
                        <div class="form-group">
                            <label for="meetingname" class="col-sm-2 control-label">会议名称:</label>
                            <div class="col-sm-10">
                                <input name="meetingname" style="width: 50%" type="text"
                                       class="form-control" id="meetingname" placeholder="会议名称">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="numofattendents" class="col-sm-2 control-label">预计参加人数:</label>
                            <div class="col-sm-10">
                                <input name="numberofparticipants" style="width: 50%" type="text"
                                       class="form-control" id="numofattendents" placeholder="预计参加人数">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="starttime" class="col-sm-2 control-label">预计开始时间:</label>
                            <div class="col-sm-10">
                                <input name="starttime" style="width: 50%" type="text"
                                       class="form-control Wdate" id="starttime" placeholder="预计开始时间"
                                       onclick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss'})">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="endtime" class="col-sm-2 control-label">预计结束时间:</label>
                            <div class="col-sm-10">
                                <input name="endtime" style="width: 50%" type="text"
                                       class="form-control Wdate" id="endtime" placeholder="预计开始时间"
                                       onclick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss'})">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="numofattendents" class="col-sm-2 control-label">会议室名称:</label>
                            <div class="col-sm-10">
                                <select name="roomid" class="form-control" style="width: 50%">
                                    <#list mrs as mr>
                                        <option value="${mr.roomid}">${mr.roomname}</option>
                                    </#list>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="description" class="col-sm-2 control-label">会议说明:</label>
                            <div class="col-sm-10">
                                <textarea class="form-control" name="description" id="description" rows="5"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="numofattendents" class="col-sm-2 control-label">选择参会人员:</label>
                            <div class="col-sm-10">
                                <div id="divfrom">
                                    <select id="selDepartments" class="form-control" onchange="fillEmployees()">
                                    </select>
                                    <select id="selEmployees" class="form-control" multiple="true">
                                    </select>
                                </div>
                                <div id="divoperator">
                                    <input type="button" class="clickbutton btn btn-default" value="&gt;" onclick="selectEmployees()"/>
                                    <input type="button" class="clickbutton btn btn-default" value="&lt;"
                                           onclick="deSelectEmployees()"/>
                                </div>
                                <div id="divto">
                                    <select name="mps" class="form-control" id="selSelectedEmployees" multiple="true">
                                    </select>
                                </div>
                            </div>
                        </div>
                        <tr>
                            <td class="command" colspan="2">
                                <input type="submit" class="clickbutton btn btn-primary" value="预定会议"/>
                                <input type="reset" class="clickbutton btn btn-default" value="重置"/>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </form>
        </div>
    </div>
</div>
<div class="page-footer">
    <hr/>
    更多问题，欢迎联系<a href="mailto:578173534@qq.com">管理员</a>
    <img src="/images/footer.png" alt="Meeting"/>
</div>
</body>
</html>