# Generated by Django 4.2.13 on 2024-06-25 05:21

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('women', '0011_women_photo'),
    ]

    operations = [
        migrations.AddField(
            model_name='women',
            name='author',
            field=models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='post', to=settings.AUTH_USER_MODEL),
        ),
    ]