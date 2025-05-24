import PIL, io, json
from PIL import Image, ImageDraw, ImageFont

def lambda_handler(event, context):
    try:
        print("Pillow test demo")
        img_width = 400
        img_height = 200
        background_color = (255, 255, 255)
        text_color = (0, 0, 0)
        img = Image.new('RGB', (img_width, img_height), background_color)
        print("Blank image created")
        d = ImageDraw.Draw(img)
        d.rectangle([(0, 0), (img_width - 1, img_height - 1)], outline=text_color, width=3)
        print("Rectangle drawn")
        font = ImageFont.load_default()
        text = "Hello from Lambda!"
        text_bbox = d.textbbox((0, 0), text, font=font)
        text_width = text_bbox[2] - text_bbox[0]
        text_height = text_bbox[3] - text_bbox[1]
        text_x = (img_width - text_width) // 2
        text_y = (img_height - text_height) // 2
        d.text((text_x, text_y), text, fill=text_color, font=font)
        print("Text drawn")
        #delete the image from memory
        del d
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Image created successfully'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
