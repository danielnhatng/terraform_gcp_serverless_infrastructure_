resource "google_monitoring_alert_policy" "petclinic-alert" {
    display_name = "CLoud run alert"
    documentation {
        content = "Reporting to Nhat-sama"
    }
    enabled = true
    combiner = "OR"
    conditions {
        display_name = "Container cpu condition"
        condition_threshold {
            filter = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/container/cpu/utilizations\""
            duration = "0s"
            comparison = "COMPARISON_GT"
        aggregations {
            alignment_period = "60s"
            cross_series_reducer = "REDUCE_NONE"
            per_series_aligner = "ALIGN_PERCENTILE_99"
        }
        trigger {
            count = 1
        }
        threshold_value = 0.8
        }
    }
    conditions {
        display_name = "Service available"
        condition_threshold {
            filter = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/container/instance_count\" AND metric.label.\"state\"=\"idle\""
            duration = "300s"
            comparison = "COMPARISON_LT"
            aggregations {
                alignment_period = "120s"
                cross_series_reducer = "REDUCE_NONE"
                per_series_aligner = "ALIGN_MAX"
            }
            trigger {
                count = 1
            }
            threshold_value = 1
        }
    }
    conditions {
        display_name = "Http 500 status code "
        condition_threshold {
            filter = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/request_count\" AND metric.label.\"response_code_class\"=\"5xx\""
            duration = "0s"
            comparison = "COMPARISON_GT"
            aggregations {
                alignment_period = "60s"
                # cross_series_reducer = "REDUCE_NONE"
                per_series_aligner = "ALIGN_SUM"
            }
            
            threshold_value = 0
        }
    }
    notification_channels = [ data.google_monitoring_notification_channel.nhatnd19-gmail.name ]
}




data "google_monitoring_notification_channel" "nhatnd19-gmail" {
    display_name = "Gmail Notification" 
}