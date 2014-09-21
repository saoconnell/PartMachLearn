answers = submission.rd.rf

pml_write_files = function(x){
    n = length(x)
    for(i in 1:n){
        filename = paste0("submission_rd_rf/problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}

pml_write_files(submission.rd.rf)