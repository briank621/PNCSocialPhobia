library("keras")
library('kerastuneR')

build_model = function(hp){
  cnn_model = keras_model_sequential() %>%
    layer_conv_1d(hp$Int('filters', min_value=4, max_value=8, step=4), kernel_size = 3, padding="same", activation="relu", input_shape=input_shape) %>% 
    layer_conv_1d(hp$Int('filters', min_value=4, max_value=8, step=4), kernel_size = 3, padding="same", activation = "relu") %>% 
    layer_max_pooling_1d(pool_size = 2) %>% 
    layer_dropout(rate = 0.2) %>% 
    layer_conv_1d(hp$Int('filters', min_value=4, max_value=8, step=4), kernel_size = 3, padding="same", activation = "relu") %>% 
    layer_conv_1d(hp$Int('filters', min_value=4, max_value=8, step=4), kernel_size = 3, padding="same", activation = "relu") %>% 
    layer_max_pooling_1d(pool_size = 2) %>% 
    layer_dropout(rate = 0.2) %>% 
    layer_flatten() %>% 
    layer_dense(units = 8, activation = "relu") %>% 
    layer_dropout(rate = 0.5) %>% 
    layer_dense(units = 4, activation = "relu") %>% 
    layer_dense(units = 1, activation = "sigmoid") %>% 
    compile(
      loss = loss_binary_crossentropy,
      optimizer = optimizer_adam(hp$Choice('learning_rate', values=c(1e-2, 1e-3, 1e-4))),
      metrics = c('accuracy')
    )
  return(cnn_model)
}

epochs = 10
batch_size = 5

tuner = RandomSearch(
  build_model,
  objective = 'val_accuracy',
  max_trials = 5,
  executions_per_trial = 3)

tuner %>% fit_tuner(x_train, y_train,
                    epochs = epochs,
                    batch_size = batch_size,
                    validation_split = 0.2)


# also tried after manually splitting
# tuner %>% fit_tuner(x_train, y_train,
#                     epochs = epochs,
#                     batch_size = batch_size,
#                     validation_data = list(x_val,y_val))