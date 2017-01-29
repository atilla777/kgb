$(document).on('ready page:load', (function() {
var defaultSortField = $('#index_table.display thead th.default_sort').index('#index_table.display thead th');
if (defaultSortField == -1)
{defaultSortField = 0;}
var defaultSortDirection = $('#index_table.display thead th.default_sort').attr('data-sort');
if (defaultSortDirection == undefined)
{defaultSortDirection = 'asc';}
$('#index_table.display').dataTable( {
"autoWidth": false,
"columnDefs": [
        { "targets": 'hiden' , 'visible': false, 'searchable': false},
        { "targets": 'order_by_hiden' , 'orderData': [0]},
        { "targets": 'w5' , "width": '5%'},
        { "targets": 'w8' , "width": '8%'},
        { "targets": 'w10' , "width": '10%'},
        { "targets": 'w12' , "width": '12%'},
        { "targets": 'w15' , "width": '15%'},
        { "targets": 'w20' , "width": '20%'},
        { "targets": 'w25' , "width": '25%'},
        { "targets": 'w30' , "width": '30%'},
        { "targets": 'w35' , "width": '35%'},
        { "targets": 'w40' , "width": '40%'},
        { "targets": 'w45' , "width": '45%'},
        { "targets": 'w50' , "width": '50%'}
    ],
"pageLength": 10,
"lengthMenu": [ 10, 20, 50, 100, 200, 500 ],
"aaSorting": [[ defaultSortField, defaultSortDirection]],
"oLanguage": {"sProcessing":   "Подождите...",
"sLengthMenu":   "Показать _MENU_ записей",
"sZeroRecords":  "Записи отсутствуют.",
"sInfo":         "Записи с _START_ до _END_ из _TOTAL_ записей",
"sInfoEmpty":    "Записи с 0 до 0 из 0 записей",
"sInfoFiltered": "(отфильтровано из _MAX_ записей)",
"sInfoPostFix":  "", "sSearch":       "Поиск:",
"sUrl":          "",
"oPaginate": {
"sFirst": "Первая",
"sPrevious": "Предыдущая",
"sNext": "Следующая",
"sLast": "Последняя"
}
}
});
var defaultSortField = $('#dt_big_table.display thead th.default_sort').index('#dt_big_table.display thead th');
if (defaultSortField == -1)
{defaultSortField = 0;}
var defaultSortDirection = $('#dt_big_table.display thead th.default_sort').attr('data-sort');
if (defaultSortDirection == undefined)
{defaultSortDirection = 'asc';}
$('#dt_big_table.display').dataTable( {
"autoWidth": false,
"columnDefs": [
        { "targets": 'w5' , "width": '5%'},
        { "targets": 'w10' , "width": '10%'},
        { "targets": 'w15' , "width": '15%'},
        { "targets": 'w20' , "width": '20%'},
        { "targets": 'w25' , "width": '25%'},
        { "targets": 'w30' , "width": '30%'},
        { "targets": 'w35' , "width": '35%'},
        { "targets": 'w40' , "width": '40%'},
        { "targets": 'w45' , "width": '45%'},
        { "targets": 'w50' , "width": '50%'}
    ],
"pageLength": 10,
"lengthMenu": [ 10, 20, 50, 100, 200, 500 ],
"bProcessing": true,
"bServerSide": true,
"sAjaxSource": $('#dt_big_table').data('source'),
"searchDelay": 1200,
"aaSorting": [[ defaultSortField, defaultSortDirection]],
"oLanguage": {"sProcessing":   "Подождите...",
"sLengthMenu":   "Показать _MENU_ записей",
"sZeroRecords":  "Записи отсутствуют.",
"sInfo":         "Записи с _START_ до _END_ из _TOTAL_ записей",
"sInfoEmpty":    "Записи с 0 до 0 из 0 записей",
"sInfoFiltered": "(отфильтровано из _MAX_ записей)",
"sInfoPostFix":  "", "sSearch":       "Поиск:",
"sUrl":          "",
"oPaginate": {
"sFirst": "Первая",
"sPrevious": "Предыдущая",
"sNext": "Следующая",
"sLast": "Последняя"
}
}
});
$.fn.dataTable.ext.errMode = 'throw';
}));

