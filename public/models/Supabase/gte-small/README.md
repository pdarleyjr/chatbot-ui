# GTE-Small Model Files

This directory contains placeholder files for the GTE-Small model used by Supabase Edge Functions.

## Required Files

For the model to work properly, you need the following files:

1. `model_quantized.onnx` - The actual model weights (binary file)
2. `config.json` - Model configuration
3. `tokenizer.json` - Tokenizer data
4. `tokenizer_config.json` - Tokenizer configuration
5. `special_tokens_map.json` - Special tokens mapping

## How to Get the Real Model Files

The files in this directory are placeholders. To get the real model files:

1. Download the model from Hugging Face: https://huggingface.co/Supabase/gte-small
2. Replace the placeholder files with the downloaded files
3. Make sure to rename the model file to `model_quantized.onnx` if it has a different name

## Deployment

When deploying to Vercel, make sure these files are included in your deployment. The Supabase Edge Functions will look for these files at `/models/Supabase/gte-small/`.